import Cocoa

public class DragAndDropView: NSTextField {
    public var dragOperation: (String) -> () = { _ in return }
    
    public convenience init() {
        self.init(frame: NSRect(x: 0, y: 0, width: 1000, height: 140))
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.isEditable = false
        self.alignment = .center
        self.backgroundColor = .controlBackgroundColor
        self.font = .systemFont(ofSize: 36.0)
        self.placeholderString = NSLocalizedString("🡇 Drag and Drop a Code File", comment: "Default placeholder string")

        self.registerForDraggedTypes([.fileURL])
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override var stringValue: String {
        get {
            return super.stringValue
        }
        
        set {
            super.stringValue = "\n\(decorate(newValue))\n"
        }
    }
    
    public override var placeholderString: String? {
        get {
            return super.placeholderString
        }
        
        set {
            guard let placeholderString = newValue else { return }
            super.placeholderString = "\n\(placeholderString)\n"
        }
    }
    
    // MARK: - NSDraggingDestination
    
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.stringValue = ""
        return .copy
    }
    
    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let path = sender.draggingPasteboard.string(forType: .fileURL),
            let url = URL(string: path),
            let contents = try? String(contentsOf: url)
            else {
                return false
        }
        
        dragOperation(contents)
        
        return true
    }
}
