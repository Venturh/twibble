import SwiftUI
import KeyboardShortcuts


final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var popover: NSPopover!
    private var statusBarItem: NSStatusItem!
    private var badgeView : BadgeView?
    private var streams : [Stream] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onStreamChange),
            name: NSNotification.Name("onStreamChange"),
            object: nil)
        
        setupContentView()
        setupStatusBar()
    }


    private func setupContentView() {
        let contentView = MainView()

        let frameSize = NSSize(width: 420, height: 522)

        // Initialize ContentView
        let hostedContentView = NSHostingView(rootView: contentView)
        hostedContentView.frame = NSRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        // Initialize Popover
        popover = NSPopover()
        popover.contentSize = frameSize
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = hostedContentView
        popover.setValue(true, forKeyPath: "shouldHideAnchor")
        popover.contentViewController?.view.window?.makeKey()


    }

    private func setupStatusBar() {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let statusBarItemButton = self.statusBarItem.button {
            statusBarItem.button?.image = NSImage(named: NSImage.Name("icon"))
            statusBarItemButton.action = #selector(togglePopover(_:))
            
            KeyboardShortcuts.onKeyUp(for: .toogleApp) { [self] in
                if popover.isShown {
                    popover.performClose(statusBarItemButton)
                } else {
                    popover.show(relativeTo: statusBarItemButton.bounds, of: statusBarItemButton, preferredEdge: .minY)
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
            }

        }
    }

    @objc func togglePopover(_ sender: NSStatusBarButton?) {

        guard let statusBarItemButton = sender else { return }

        if popover.isShown {
            popover.performClose(statusBarItemButton)
        } else {
            popover.show(relativeTo: statusBarItemButton.bounds, of: statusBarItemButton, preferredEdge: .minY)
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }

    @objc func onStreamChange(_ notification: NSNotification){
        guard let count = notification.userInfo?["count"] as? Int else { return }
        setBadge(num: count)
    }

    func setBadge(num : Int)
    {
        if num == 0 {
            if let view = badgeView {
                view.removeFromSuperview()
                badgeView = nil
            }
        } else {
            if let badgeView = badgeView {
                badgeView.number = num
            } else {
                badgeView = BadgeView(frame: NSRect(x: 6, y: 6, width: 30, height: 28), number: num)
                statusBarItem.button!.addSubview(badgeView!)
            }
        }
    }

}


@main
struct TwizzlApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}



