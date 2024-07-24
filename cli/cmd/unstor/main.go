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
		fmt.Println("Usage: go run unstor.go <manifest_file>")
		os.Exit(1)
	}

	manifestFile := os.Args[1]

	// Read the manifest file
	manifestData, err := os.ReadFile(manifestFile)
	if err != nil {
		log.Fatalf("Error reading manifest file: %v", err)
	}

	// Unmarshal the manifest file
	var manifest Manifest
	err = yaml.Unmarshal(manifestData, &manifest)
	if err != nil {
		log.Fatalf("Error unmarshalling manifest file: %v", err)
	}

	// Process each entry in the manifest
	for _, entry := range manifest.Entries {
		// Expand any ~ in the paths to the home directory
		originalPath := expandPath(entry.OriginalPath)
		newPath := expandPath(entry.NewPath)

		// Check if the new path exists
		if _, err := os.Stat(newPath); os.IsNotExist(err) {
			log.Printf("New path does not exist, skipping: %s", newPath)
			continue
		}

		// Remove the symlink if it exists
		if err := os.Remove(originalPath); err != nil && !os.IsNotExist(err) {
			log.Fatalf("Error removing symlink at %s: %v", originalPath, err)
		}

		// Move the file back to the original location
		if err := os.Rename(newPath, originalPath); err != nil {
			log.Fatalf("Error moving file from %s to %s: %v", newPath, originalPath, err)
		}

		log.Printf("Restored '%s' to its original location: %s", filepath.Base(newPath), originalPath)
	}

	log.Println("Restoration complete.")
}

// expandPath expands the ~ to the user's home directory
func expandPath(path string) string {
	if path[:2] == "~/" {
		home, err := os.UserHomeDir()
		if err != nil {
			log.Fatalf("Error getting user home directory: %v", err)
		}
		return filepath.Join(home, path[2:])
	}
	return path
}
