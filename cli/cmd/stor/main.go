package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"gopkg.in/yaml.v3"
)

type ManifestEntry struct {
	OriginalPath string `yaml:"original_path"`
	NewPath      string `yaml:"new_path"`
}

type Manifest struct {
	Entries []ManifestEntry `yaml:"entries"`
}

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run move_and_symlink.go <path>")
		os.Exit(1)
	}

	path := os.Args[1]

	// Check if the path exists
	_, err := os.Stat(path)
	if os.IsNotExist(err) {
		log.Fatalf("Path does not exist: %s", path)
	}

	// Get the absolute path
	absPath, err := filepath.Abs(path)
	if err != nil {
		log.Fatalf("Error getting absolute path: %v", err)
	}

	// Get the base name
	name := filepath.Base(absPath)

	// Get the current working directory
	// This is where we are going to place the original file/directory
	currentDir, err := os.Getwd()
	if err != nil {
		log.Fatalf("Error getting current directory: %v", err)
	}

	// Create a backup of the original file/directory
	// Instead of move we are doing
	backupPath := absPath + ".bak"
	if err := os.Rename(absPath, backupPath); err != nil {
		log.Fatalf("Error creating backup of the original file or directory: %v", err)
	}

	// Move the file or directory from the backup location to the current directory
	destPath := filepath.Join(currentDir, name)
	if err := os.Rename(backupPath, destPath); err != nil {
		// If an error occurs, move the backup file back to its original location
		os.Rename(backupPath, absPath)
		log.Fatalf("Error moving file or directory to final destination: %v", err)
	}

	// Ensure no existing file at the original path
	if err := os.Remove(absPath); err != nil && !os.IsNotExist(err) {
		log.Fatalf("Error removing existing file at original path: %v", err)
	}

	// Create a symlink back to its original location
	if err := os.Symlink(destPath, absPath); err != nil {
		// If an error occurs, move the backup file back to its original location and remove the symlink
		os.Rename(destPath, absPath)
		log.Fatalf("Error creating symlink: %v", err)
	}

	// Log the operation in manifest.yaml
	entry := ManifestEntry{OriginalPath: absPath, NewPath: destPath}
	addToManifest(entry, currentDir)

	log.Printf("'%s' moved to the current directory and symlinked back to its original location.\n", name)
}

func addToManifest(entry ManifestEntry, currentDir string) {
	manifestPath := filepath.Join(currentDir, "manifest.yaml")
	var manifest Manifest

	// Read the existing manifest file if it exists
	if _, err := os.Stat(manifestPath); err == nil {
		file, err := os.ReadFile(manifestPath)
		if err != nil {
			log.Fatalf("Error reading manifest file: %v", err)
		}
		if err := yaml.Unmarshal(file, &manifest); err != nil {
			log.Fatalf("Error unmarshalling manifest file: %v", err)
		}
	}

	// Add the new entry to the manifest
	manifest.Entries = append(manifest.Entries, entry)

	// Write the updated manifest back to the file
	file, err := os.Create(manifestPath)
	if err != nil {
		log.Fatalf("Error creating manifest file: %v", err)
	}
	defer file.Close()

	encoder := yaml.NewEncoder(file)
	defer encoder.Close()
	if err := encoder.Encode(&manifest); err != nil {
		log.Fatalf("Error encoding manifest file: %v", err)
	}
}
