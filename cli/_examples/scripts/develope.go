package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"sync"
	"syscall"
	"time"

	ui "github.com/gizak/termui/v3"
	"github.com/gizak/termui/v3/widgets"
)

type Process struct {
	Name    string
	Cmd     *exec.Cmd
	Status  string
	LogText *widgets.List
	LogChan chan string
	ErrChan chan string
	Mutex   sync.Mutex
	Running bool
}

var processes []*Process
var tabPane *widgets.TabPane
var logDisplay *widgets.List // Secondary display for logs
var globalMutex sync.Mutex
var autoScroll bool = true

func main() {
	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	if len(os.Args) < 2 {
		log.Fatal("Usage: go run scripts/develop.go <path>")
	}
	rootDir := os.Args[1]

	processes = findAndSetupProcesses(rootDir)
	grid := createGrid()
	initializeUI()

	uiEvents := ui.PollEvents()
	ticker := time.NewTicker(500 * time.Millisecond)
	defer ticker.Stop()

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	for {
		select {
		case <-sigChan:
			cleanup()
			return
		case e := <-uiEvents:
			if handleEvent(e) {
				cleanup()
				return
			}
			renderActiveTab()
		case <-ticker.C:
			renderActiveTab()
		}
		ui.Render(grid)
	}
}

func cleanup() {
	for _, proc := range processes {
		proc.Running = false
		if proc.Cmd != nil && proc.Cmd.Process != nil {
			proc.Cmd.Process.Kill()
		}
		time.Sleep(100 * time.Millisecond)
		close(proc.LogChan)
		close(proc.ErrChan)
	}
	ui.Close()
}

func createGrid() *ui.Grid {
	grid := ui.NewGrid()
	termWidth, termHeight := ui.TerminalDimensions()
	grid.SetRect(0, 0, termWidth, termHeight)

	helpBar := widgets.NewParagraph()
	helpBar.Text = "Press 'q' to quit, '<Left>' and '<Right>' to switch tabs, 'j' and 'k' to scroll, 'g' and 'G' to go to top and bottom"
	tabPane = widgets.NewTabPane()
	tabPane.Border = true
	tabPane.ActiveTabStyle = ui.NewStyle(ui.ColorBlack, ui.ColorGreen, ui.ModifierUnderline)
	tabPane.InactiveTabStyle = ui.NewStyle(ui.ColorMagenta, ui.ColorClear)
	tabPane.Block.Title = "Processes"

	logDisplay = widgets.NewList()
	logDisplay.Border = true
	logDisplay.SelectedRowStyle = ui.NewStyle(ui.ColorGreen)
	logDisplay.WrapText = true
	logDisplay.Title = "Logs"

	grid.Set(
		ui.NewRow(.1, tabPane),
		ui.NewRow(0.7, logDisplay),
		ui.NewRow(.15, helpBar),
	)

	return grid
}

func handleEvent(e ui.Event) bool {
	switch e.ID {
	case "q", "<C-c>":
		return true
	case "<Left>", "l":
		tabPane.FocusLeft()
	case "<Right>", "j":
		tabPane.FocusRight()
	case "k", "<Down>":
		autoScroll = false
		logDisplay.ScrollDown()
	case "i", "<Up>":
		autoScroll = false
		logDisplay.ScrollUp()
	case "<C-d>":
		autoScroll = false
		logDisplay.ScrollHalfPageDown()
	case "<C-u>":
		autoScroll = false
		logDisplay.ScrollHalfPageUp()
	case "<C-f>":
		autoScroll = false
		logDisplay.ScrollPageDown()
	case "<C-b>":
		autoScroll = false
		logDisplay.ScrollPageUp()
	case "g", "<Home>":
		autoScroll = false
		logDisplay.ScrollTop()
	case "G", "<End>":
		logDisplay.ScrollBottom()
		autoScroll = true
	}
	return false
}

func findAndSetupProcesses(root string) []*Process {
	var processes []*Process
	filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if filepath.Base(path) == "skaffold.yaml" {
			dir := filepath.Dir(path)
			cmd := exec.Command("skaffold", "run")
			cmd.Dir = dir
			process := &Process{
				Name:    dir,
				Cmd:     cmd,
				LogText: widgets.NewList(),
				LogChan: make(chan string, 100),
				ErrChan: make(chan string, 100),
			}
			process.LogText.Title = path
			process.LogText.WrapText = true
			process.Cmd.Env = os.Environ() // Inherit environment
			process.Running = true
			processes = append(processes, process)
			go runProcess(process)
		}
		return nil
	})
	return processes
}

func runProcess(p *Process) {
	stdout, _ := p.Cmd.StdoutPipe()
	stderr, _ := p.Cmd.StderrPipe()

	go captureOutput(stdout, p.LogChan, p)
	go captureOutput(stderr, p.ErrChan, p)

	if err := p.Cmd.Start(); err != nil {
		p.LogChan <- fmt.Sprintf("Error starting process: %v", err)
		p.Status = "Error"
		appendLog(p, err.Error(), true)
		updateUI(p)
		return
	}

	go func() {
		for log := range p.LogChan {
			appendLog(p, log, false)
		}
		for err := range p.ErrChan {
			appendLog(p, err, true)
		}
	}()

	p.Status = "Running"
	updateUI(p)
	if err := p.Cmd.Wait(); err != nil {
		p.LogChan <- fmt.Sprintf("Process ended with error: %v", err)
		p.Status = "Error"
	}
	updateUI(p)
}

func captureOutput(pipe io.ReadCloser, channel chan<- string, proc *Process) {
	scanner := bufio.NewScanner(pipe)
	for scanner.Scan() && proc.Running {
		channel <- scanner.Text()
	}
	close(channel)
}

func appendLog(p *Process, log string, isError bool) {
	timestamp := time.Now().Format("15:04:05")
	formattedLog := fmt.Sprintf("%s > %s", timestamp, log)
	p.Mutex.Lock()
	p.LogText.Rows = append(p.LogText.Rows, formattedLog)
	p.Mutex.Unlock()
	if autoScroll {
		scrollToLatest(p)
	}
}

func scrollToLatest(p *Process) {
	p.Mutex.Lock()
	defer p.Mutex.Unlock()

	lastRow := len(p.LogText.Rows) - 1
	if lastRow < 0 {
		lastRow = 0
	}
	p.LogText.SelectedRow = lastRow

	if tabPane.ActiveTabIndex >= 0 && processes[tabPane.ActiveTabIndex] == p {
		logDisplay.SelectedRow = lastRow
	}
}

func initializeUI() {
	termWidth, _ := ui.TerminalDimensions()
	tabPane.SetRect(0, 0, termWidth, 3)
	for _, proc := range processes {
		tabPane.TabNames = append(tabPane.TabNames, fmt.Sprintf("%s (?) %s", proc.Name, "Starting"))
	}
	ui.Render(tabPane, logDisplay)
}

func updateUI(proc *Process) {
	globalMutex.Lock()
	defer globalMutex.Unlock()

	index := findProcessIndex(proc)
	if index == -1 {
		return // Process not found
	}

	if proc.Cmd.Process != nil {
		tabPane.TabNames[index] = fmt.Sprintf("%s (%d) %s", proc.Name, proc.Cmd.Process.Pid, proc.Status)
	} else {
		tabPane.TabNames[index] = fmt.Sprintf("%s (?) %s", proc.Name, proc.Status)
	}
	if index == tabPane.ActiveTabIndex {
		logDisplay.Rows = proc.LogText.Rows
		scrollToLatest(proc)
	}
}

func findProcessIndex(proc *Process) int {
	for i, p := range processes {
		if p == proc {
			return i
		}
	}
	return -1
}

func renderActiveTab() {
	if tabPane.ActiveTabIndex >= 0 && tabPane.ActiveTabIndex < len(processes) {
		p := processes[tabPane.ActiveTabIndex]
		logDisplay.Rows = p.LogText.Rows
		scrollToLatest(p)
	}
}
