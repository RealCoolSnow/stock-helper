import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: false)
    self.setContentSize(NSSize(width: 400, height: 640))
    let window:NSWindow! = self.contentView?.window
    window.styleMask.remove(.resizable)
    window.titleVisibility = .hidden
    
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
