import Foundation
import SwiftUI
import KeyboardShortcuts

struct KeyAware: NSViewRepresentable {
    let onEvent: (Event) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        view.onEvent = onEvent
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

extension KeyAware {
    enum Event {
        case upArrow
        case downArrow
        case leftArrow
        case rightArrow
        case `return`
        case space
        case cmdC
    }
}

private class KeyView: NSView {
    var onEvent: (KeyAware.Event) -> Void = { _ in }
    
    override var acceptsFirstResponder: Bool { true }
    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case KeyboardShortcuts.Key.upArrow.rawValue:
            onEvent(.upArrow)
        case KeyboardShortcuts.Key.downArrow.rawValue:
            onEvent(.downArrow)
        case KeyboardShortcuts.Key.return.rawValue:
            onEvent(.return)
        case KeyboardShortcuts.Key.space.rawValue:
            onEvent(.space)
        case KeyboardShortcuts.Key.c.rawValue where event.modifierFlags.contains(.command):
            onEvent(.cmdC)
        default:
            super.keyDown(with: event)
        }
    }
}
