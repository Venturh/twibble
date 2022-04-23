import AppKit

class BadgeView: NSView {
    
    var number : Int {
        didSet {
            if oldValue != number { needsDisplay = true }
        }
    }
    
    init(frame frameRect: NSRect, number : Int) {
        self.number = number
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        self.number = 0
        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let fillColor = NSColor.systemGray
        let path = NSBezierPath(ovalIn: NSRect(x: 0, y: 12, width: 12.5, height: 11))
        fillColor.set()
        path.fill()
        var one = "\(number)";
        if(number > 99){
            one = "99+"
        }
        let attribs : [NSAttributedString.Key:Any] = [.font : NSFont.systemFont(ofSize: 8), .foregroundColor : NSColor.textBackgroundColor]
        var xOrigin = 4.0
        if(number > 9) {
            xOrigin = 2.5
        }else if (number > 99){
            xOrigin = 2.5
        }
        one.draw(at: NSPoint(x: xOrigin, y: 12.5), withAttributes: attribs)
    }
}
