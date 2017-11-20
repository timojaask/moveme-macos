import Cocoa

class ViewController: NSViewController {
    var timer: Timer?
    let defaultTargetTimeSeconds = 20 * 60
    var targetTimeSeconds = 20 * 60
    var passedTimeSecconds = 0
    var timeStarted: Date?
    var sessionTimePassedSeconds = 0
    
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var timeLeftLabel: NSTextField!
    
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var startButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTargetTimeFromSettings()
        updateTimeView()
        updateButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(onSettingsChanged(notification:)), name: Notifications.TargetTimeUpdated, object: nil)
    }
    
    @objc func onSettingsChanged(notification: Notification) {
        loadTargetTimeFromSettings()
        updateTimeView()
    }
    
    func loadTargetTimeFromSettings() {
        let minutes = LocalStorage.loadNumberOfMinutes()
        targetTimeSeconds = minutes < 1 ? defaultTargetTimeSeconds : minutes * 60;
    }
    
    func isStopped() -> Bool {
        return timer == nil && passedTimeSecconds == 0
    }
    
    func isPaused() -> Bool {
        return timer == nil && passedTimeSecconds > 0
    }
    
    func isRunning() -> Bool {
        return timer != nil
    }
    
    func secondsToTimeString(totalSeconds: Int) -> String {
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds % 60)
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let timeString = "\(minutes):\(secondsString)"
        return timeString
    }
    
    func updateTimeView() {
        if isStopped() {
            timeLeftLabel.stringValue = secondsToTimeString(totalSeconds: targetTimeSeconds)
            statusLabel.stringValue = "STOPPED"
        }
        if isPaused() {
            let timeLeftSeconds = targetTimeSeconds - passedTimeSecconds
            timeLeftLabel.stringValue = secondsToTimeString(totalSeconds: timeLeftSeconds)
            statusLabel.stringValue = "PAUSED"
        }
        if isRunning() {
            let totalTimePassed = passedTimeSecconds + sessionTimePassedSeconds
            let timeLeftSeconds = targetTimeSeconds - totalTimePassed
            timeLeftLabel.stringValue = secondsToTimeString(totalSeconds: timeLeftSeconds)
            statusLabel.stringValue = "RUNNING"
        }
    }
    
    func updateButtons() {
        startButton.isEnabled = !isRunning()
        pauseButton.isEnabled = isRunning()
        stopButton.isEnabled = !isStopped()
        startButton.title = isPaused() ? "Resume" : "Start"
    }
    
    func onTimerTick() {
        sessionTimePassedSeconds = Int(timeStarted?.timeIntervalSinceNow ?? 0) * -1
        
        updateTimeView()
        let totalTimePassed = passedTimeSecconds + sessionTimePassedSeconds
        if totalTimePassed >= targetTimeSeconds {
            onTargetTimeReached()
        }
    }
    
    func onTargetTimeReached() {
        view.window?.deminiaturize(nil)
        stopTimer()
        showTimeIsUpPopUp()
    }
    
    func showTimeIsUpPopUp() {
        print("Making key and ordering front")
        NSApp.activate(ignoringOtherApps: true)
        NSApp.mainWindow?.makeKeyAndOrderFront(self)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "timeIsUpSegue"), sender: self)
        }
    }
    
    func startTimer() {
        timeStarted = Date()
        sessionTimePassedSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            DispatchQueue.main.async {
                self.onTimerTick()
            }
        })
        updateTimeView()
        updateButtons()
    }
    
    func pauseTimer() {
        passedTimeSecconds += sessionTimePassedSeconds
        clearTimerInstance()
        updateTimeView()
        updateButtons()
    }
    
    func stopTimer() {
        passedTimeSecconds = 0
        clearTimerInstance()
        updateTimeView()
        updateButtons()
    }
    
    func clearTimerInstance() {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        startTimer()
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
        pauseTimer()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        stopTimer()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

