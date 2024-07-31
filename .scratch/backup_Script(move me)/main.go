package main

import (
	"archive/tar"
	"compress/gzip"
	"crypto/md5"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"github.com/jedib0t/go-pretty/v6/progress"
)

var (
	backupDir string
	srcDirs   []string
)

func expandPath(path string) string {
	if strings.HasPrefix(path, "~/") {
		homeDir, err := os.UserHomeDir()
		if err != nil {
			fmt.Printf("Error getting user home directory: %v\n", err)
			return path
		}
		return strings.Replace(path, "~", homeDir, 1)
	}
	return path
}

func backupDirectory(srcDir string, wg *sync.WaitGroup, tracker *progress.Tracker) {
	defer wg.Done()

	// Start counting files in a separate goroutine
	var totalFiles int64
	var countWg sync.WaitGroup
	countWg.Add(1)
	go func() {
		defer countWg.Done()
		totalFiles = countFiles(srcDir)
		tracker.UpdateTotal(totalFiles)
	}()

	backupPrefix := filepath.Base(srcDir) + ".backup.tar.gz"
	backupFile := filepath.Join(backupDir, time.Now().Format("2006-01-02"), backupPrefix)
	checksumFile := filepath.Join(backupDir, time.Now().Format("2006-01-02"), filepath.Base(srcDir)+".checksum")

	err := os.MkdirAll(filepath.Dir(backupFile), os.ModePerm)
	if err != nil {
		fmt.Printf("Error creating backup directory: %v\n", err)
		return
	}

	file, err := os.Create(backupFile)
	if err != nil {
		fmt.Printf("Error creating backup file: %v\n", err)
		return
	}
	defer file.Close()

	gzipWriter := gzip.NewWriter(file)
	defer gzipWriter.Close()

	tarWriter := tar.NewWriter(gzipWriter)
	defer tarWriter.Close()

	checksumData := make([]byte, 0)

	err = filepath.Walk(srcDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if !info.Mode().IsRegular() {
			return nil
		}

		file, err := os.Open(path)
		if err != nil {
			return err
		}

		defer file.Close()

		relativePath := strings.TrimPrefix(path, srcDir+string(os.PathSeparator))

		header, err := tar.FileInfoHeader(info, "")
		if err != nil {
			return err
		}
		header.Name = relativePath

		if err := tarWriter.WriteHeader(header); err != nil {
			return err
		}

		if _, err := io.Copy(tarWriter, file); err != nil {
			return err
		}

		hash := md5.New()
		if _, err := io.Copy(hash, file); err != nil {
			return err
		}
		checksumData = append(checksumData, []byte(fmt.Sprintf("%x  %s\n", hash.Sum(nil), relativePath))...)

		tracker.UpdateMessage("Processing " + srcDir)
		tracker.Increment(1)

		return nil
	})

	if err != nil {
		fmt.Printf("Error walking directory: %v\n", err)
		return
	}

	// Wait for the file counting goroutine to finish
	countWg.Wait()
	// tracker.UpdateTotal(totalFiles)

	err = os.WriteFile(checksumFile, checksumData, os.ModePerm)
	if err != nil {
		fmt.Printf("Error writing checksum file: %v\n", err)
		return
	}

	time.Sleep(time.Second) // Delay to display the final progress state
}

func countFiles(dir string) int64 {
	var count int64
	filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.Mode().IsRegular() {
			count++
		}
		return nil
	})
	return count
}

func main() {
	srcDirsEnv := os.Getenv("BACKUP_SOURCE_DIRS")
	if srcDirsEnv == "" {
		fmt.Println("Please set the BACKUP_SOURCE_DIRS environment variable with comma-separated directory paths")
		return
	}

	backupDirEnv := os.Getenv("BACKUP_DEST_DIR")
	if backupDirEnv == "" {
		fmt.Println("Please set the BACKUP_DEST_DIR environment variable with the backup destination directory path")
		return
	}

	srcDirs = strings.Split(srcDirsEnv, ",")
	for i, dir := range srcDirs {
		srcDirs[i] = expandPath(strings.TrimSpace(dir))
	}

	backupDir = expandPath(backupDirEnv)

	var wg sync.WaitGroup
	pw := progress.NewWriter()
	pw.SetAutoStop(false)
	pw.SetNumTrackersExpected(len(srcDirs))
	pw.SetSortBy(progress.SortByPercentDsc)
	pw.SetStyle(progress.StyleDefault)
	pw.SetTrackerPosition(progress.PositionRight)
	pw.SetUpdateFrequency(time.Millisecond * 100)
	pw.Style().Colors = progress.StyleColorsExample
	pw.Style().Options.PercentFormat = "%4.1f%%"
	go pw.Render()

	for _, srcDir := range srcDirs {
		// Probably can append tracker here and create it....
		wg.Add(1)
		// var currentFile string
		tracker := progress.Tracker{
			Total: 0,
			Units: progress.Units{
				Notation: "total files  ",
			},
			Message: fmt.Sprintf("Gathering %s", srcDir),
		}
		pw.AppendTracker(&tracker)
		go backupDirectory(srcDir, &wg, &tracker)
	}

	wg.Wait()
	pw.Stop()
}
