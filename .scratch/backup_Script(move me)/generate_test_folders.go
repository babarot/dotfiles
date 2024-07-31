// data_generator.go

package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strconv"
)

const (
	fileSize = 1024 * 1024 * 1024 // 1MB
)

func generateTestData(baseDir string, folderNum int) error {
	// Create the base directory
	err := os.Mkdir(baseDir, os.ModePerm)
	if err != nil {
		return fmt.Errorf("error creating base directory: %v", err)
	}

	// Create folders with varying number of files
	for i := 1; i <= folderNum; i++ {
		folderName := strconv.Itoa(i)
		folderPath := filepath.Join(baseDir, folderName)

		// Create the folder
		err := os.Mkdir(folderPath, os.ModePerm)
		if err != nil {
			fmt.Printf("Error creating folder %s: %v\n", folderName, err)
			continue
		}

		// Create files inside the folder
		for j := 1; j <= i; j++ {
			fileName := fmt.Sprintf("file%d.txt", j)
			filePath := filepath.Join(folderPath, fileName)

			// Create a 1MB file
			data := make([]byte, fileSize)
			err := ioutil.WriteFile(filePath, data, os.ModePerm)
			if err != nil {
				fmt.Printf("Error creating file %s: %v\n", fileName, err)
				continue
			}
		}

		fmt.Printf("Created folder %s with %d files\n", folderName, i)
	}

	return nil
}

func main() {
	// Parse command-line flags
	baseDir := flag.String("dir", "test_data", "Base directory for generating test data")
	folderNum := flag.Int("folders", 20, "Number of folders to generate")
	flag.Parse()

	// Generate test data
	err := generateTestData(*baseDir, *folderNum)
	if err != nil {
		fmt.Printf("Error generating test data: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("Test data generated successfully.")
}
