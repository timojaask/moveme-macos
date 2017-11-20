import Cocoa

class TimeIsUpViewController: NSViewController {
    override func viewDidAppear() {
        view.window?.level = .floating
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        view.window?.performClose(nil)
    }
    
}
