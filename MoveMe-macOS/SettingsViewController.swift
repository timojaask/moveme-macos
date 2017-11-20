import Cocoa

class SettingsViewController: NSViewController {
    
    @IBOutlet weak var minutesTextField: NSTextField!
    
    override func viewDidAppear() {
        view.window?.level = .floating
        minutesTextField.intValue = Int32(LocalStorage.loadNumberOfMinutes())
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let minutes = Int(minutesTextField.intValue)
        guard minutes > 0 else {
            showAlert(question: "Invalid time", text: "Please enter how many minutes you'd like to work. Make that number larger than 0")
            return
        }
        LocalStorage.saveNumberOfMinutes(minutes: minutes)
        NotificationCenter.default.post(name: Notifications.TargetTimeUpdated, object: nil)
        closeWindow()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        closeWindow()
    }
    
    func closeWindow() {
        view.window?.performClose(nil)
    }
    
    func showAlert(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

