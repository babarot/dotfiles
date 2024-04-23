package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"strings"
	"sync"
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
}

var processes []*Process
var tabPane *widgets.TabPane
var logDisplay *widgets.List // Secondary display for logs
var globalMutex sync.Mutex

var autoScroll bool = true

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <command1> <command2> ...", os.Args[0])
	}

	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	processes = setupProcesses(os.Args[1:])
	grid := createGrid()
	initializeUI()

	uiEvents := ui.PollEvents()
	ticker := time.NewTicker(500 * time.Millisecond)
	defer ticker.Stop()

	for {
		select {
		case e := <-uiEvents:
			handleEvent(e)
			renderActiveTab()
		case <-ticker.C:
			renderActiveTab()
		}
		ui.Render(grid)
	}
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
	tabPane.InactiveTabStyle = ui.NewStyle(ui.ColorBlack, ui.ColorClear)
	tabPane.Block.Title = "Processes"

	logDisplay = widgets.NewList()
	logDisplay.Border = true
	logDisplay.SelectedRowStyle = ui.NewStyle(ui.ColorYellow)
	logDisplay.WrapText = true
	logDisplay.Title = "Logs"

	grid.Set(
		ui.NewRow(.1, tabPane),
		ui.NewRow(0.7, logDisplay),
		ui.NewRow(.15, helpBar),
	)

	return grid
}

func handleEvent(e ui.Event) {
	switch e.ID {
	case "q", "<C-c>":
		ui.Close()
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
}

func setupProcesses(commands []string) []*Process {
	processes := make([]*Process, len(commands))
	for i, cmd := range commands {
		parts := strings.SplitN(cmd, " ", 2)
		processes[i] = &Process{
			Name:    parts[0],
			Cmd:     exec.Command(parts[0], parts[1:]...),
			Status:  "Starting",
			LogText: widgets.NewList(),
			LogChan: make(chan string, 100),
			ErrChan: make(chan string, 100),
		}
		processes[i].LogText.Title = "Logs for " + parts[0]
		processes[i].LogText.WrapText = true
		processes[i].Cmd.Env = os.Environ() // Inherit environment
		go runProcess(processes[i], i)
	}
	return processes
}

func runProcess(p *Process, index int) {
	stdout, _ := p.Cmd.StdoutPipe()
	stderr, _ := p.Cmd.StderrPipe()

	go captureOutput(stdout, p.LogChan)
	go captureOutput(stderr, p.ErrChan)

	if err := p.Cmd.Start(); err != nil {
		p.LogChan <- fmt.Sprintf("Error starting process: %v", err)
		p.Status = "Error"
		appendLog(p, err.Error(), true)
		updateUI(index)
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
	updateUI(index)
	if err := p.Cmd.Wait(); err != nil {
		p.LogChan <- fmt.Sprintf("Process ended with error: %v", err)
		p.Status = "Error"
	}
	updateUI(index)
}

func captureOutput(pipe io.ReadCloser, channel chan<- string) {
	scanner := bufio.NewScanner(pipe)
	for scanner.Scan() {
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
	for i := range processes {
		tabPane.TabNames = append(tabPane.TabNames, fmt.Sprintf("%s (?) %s", processes[i].Name, "Starting"))
	}
	ui.Render(tabPane, logDisplay)
}

func updateUI(index int) {
	globalMutex.Lock()
	defer globalMutex.Unlock()

	p := processes[index]
	if p.Cmd.Process != nil {
		tabPane.TabNames[index] = fmt.Sprintf("%s (%d) %s", p.Name, p.Cmd.Process.Pid, p.Status)
	} else {
		tabPane.TabNames[index] = fmt.Sprintf("%s (?) %s", p.Name, p.Status)
	}
	if index == tabPane.ActiveTabIndex {
		logDisplay.Rows = p.LogText.Rows
		scrollToLatest(p)
	}
}

func renderActiveTab() {
	if tabPane.ActiveTabIndex >= 0 && tabPane.ActiveTabIndex < len(processes) {
		p := processes[tabPane.ActiveTabIndex]
		logDisplay.Rows = p.LogText.Rows
		scrollToLatest(p)
	}
}
