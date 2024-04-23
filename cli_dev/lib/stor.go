package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Usage: go run move_and_symlink.go <file_path>")
		os.Exit(1)
	}

	filePath := os.Args[1]

	// Check if the file exists
	if _, err := os.Stat(filePath); os.IsNotExist(err) {
		fmt.Println("File does not exist:", filePath)
		os.Exit(1)
	}

	// Get the absolute path of the file
	absFilePath, err := filepath.Abs(filePath)
	if err != nil {
		fmt.Println("Error getting absolute path:", err)
		os.Exit(1)
	}

	// Get the base name of the file
	fileName := filepath.Base(absFilePath)

	// Get the current working directory
	currentDir, err := os.Getwd()
	if err != nil {
		fmt.Println("Error getting current directory:", err)
		os.Exit(1)
	}

	// Move the file to the current directory
	destFilePath := filepath.Join(currentDir, fileName)
	if err := os.Rename(absFilePath, destFilePath); err != nil {
		fmt.Println("Error moving file:", err)
		os.Exit(1)
	}

	// Create a symlink of the file back to its original location
	if err := os.Symlink(destFilePath, absFilePath); err != nil {
		fmt.Println("Error creating symlink:", err)
		os.Exit(1)
	}

	fmt.Printf("File '%s' moved to the current directory and symlinked back to its original location.\n", fileName)
}
