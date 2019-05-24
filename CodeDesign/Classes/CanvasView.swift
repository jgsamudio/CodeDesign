//
//  CanvasViewController.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/20/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//
import Foundation
import Cocoa

enum KeyboardCommand: CaseIterable {
    case centerCanvas
    case increaseMagnification
    case decreaseMagnification
    
    /// Returns a KeyboardCommand if one is found in the given set.
    ///
    /// - Parameter keys: Keys to check for a command.
    /// - Returns: Optional KeyboardCommand.
    static func command(from keys: Set<Int>) -> KeyboardCommand? {
        for command in KeyboardCommand.allCases {
            if command.commandKeys == keys {
                return command
            }
        }
        return nil
    }
    
    /// The command key codes in a set.
    var commandKeys: Set<Int> {
        switch self {
        case .centerCanvas:
            return [18, Int(NSEvent.ModifierFlags.command.rawValue)]
        case .increaseMagnification:
            return [24, Int(NSEvent.ModifierFlags.command.rawValue)]
        case .decreaseMagnification:
            return [27, Int(NSEvent.ModifierFlags.command.rawValue)]
        }
    }
}

protocol CommandHandlerDelegate: class {
    
    /// Delegate handler for a received keyboard command.
    ///
    /// - Parameter command: KeyboardCommand type identified as received.
    func handleKeyboardCommand(_ command: KeyboardCommand)
    
}

class CommandHandler {
    
    /// Delegate for handling the a keyboard command.
    weak var delegate: CommandHandlerDelegate?
    
    /// Flag to determine if the command is active.
    var commandActive: Bool {
        return KeyboardCommand.command(from: pressedKeys) != nil
    }
    
    private var pressedKeys = Set<Int>()
    
    /// Handles the keyboard key down action and checks for a valid command.
    ///
    /// - Parameters:
    ///   - code: Key code.
    ///   - modifierFlags: Event modifier flags. These handle `command` and `option` keys.
    func keyDown(code: Int, modifierFlags: NSEvent.ModifierFlags) {
        // https://stackoverflow.com/questions/32446978/swift-capture-keydown-from-nsviewcontroller
        let intersectedModifierFlags = modifierFlags.intersection(.deviceIndependentFlagsMask)
        pressedKeys.insert(Int(intersectedModifierFlags.rawValue))
        pressedKeys.insert(code)
        checkForCommand()
    }
    
    /// Handles the keyboard key up action and checks for a valid command.
    ///
    /// - Parameters:
    ///   - code: Key code.
    ///   - modifierFlags: Event modifier flags. These handle `command` and `option` keys.
    func keyUp(code: Int, modifierFlags: NSEvent.ModifierFlags) {
        let intersectedModifierFlags = modifierFlags.intersection(.deviceIndependentFlagsMask)
        pressedKeys.remove(Int(intersectedModifierFlags.rawValue))
        pressedKeys.remove(code)
        checkForCommand()
    }
    
}

private extension CommandHandler {
    
    func checkForCommand() {
        if let command = KeyboardCommand.command(from: pressedKeys) {
            delegate?.handleKeyboardCommand(command)
        }
    }
    
}

class CanvasClipView: NSClipView {
    
    var blockScrolling = false
    
    private var centerClipView = false
    private var scrollPoint: NSPoint?
    private var scrollingLength: CGFloat = 0
    
    init(canvasSize: NSSize) {
        super.init(frame: NSRect.zero)
        documentView = NSView(frame: NSRect(origin: CGPoint.zero, size: canvasSize))
        postsBoundsChangedNotifications = true
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        documentView = NSView(frame: NSRect(origin: CGPoint.zero, size: NSSize.zero))
        postsBoundsChangedNotifications = true
    }
    
    deinit {
        guard superview is NSScrollView else { return }
        NotificationCenter.default.removeObserver(self,
                                                  name: NSView.boundsDidChangeNotification,
                                                  object: self)
    }
    
    override func layout() {
        super.layout()
        guard superview is NSScrollView else { return }
        // https://stackoverflow.com/questions/13901508/how-to-find-out-whether-nsscrollview-is-currently-scrolling
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrollViewDidScroll),
                                               name: NSView.boundsDidChangeNotification,
                                               object: self)
    }
    
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        var rect = super.constrainBoundsRect(proposedBounds)
        
        if blockScrolling {
            rect = bounds
        } else if centerClipView {
            rect.origin.x = (documentRect.width - rect.width) / 2
            rect.origin.y = (documentRect.height - rect.height) / 2
        } else if let scrollPoint = scrollPoint {
            rect.origin.x = scrollPoint.x - rect.width/2
            rect.origin.y = scrollPoint.y - rect.height/2
        }
        return rect
    }
    
    /// Centers the document view.
    func centerDocumentView() {
        centerClipView = true
        scroll(NSPoint.zero)
    }
    
    /// Scrolls to the center of the view provided.
    ///
    /// - Parameter view: view to scroll to.
    func scrollToCenter(of view: NSView) {
        let xOrigin = view.frame.minX + ((view.frame.maxX - view.frame.minX) / 2)
        let yOrigin = view.frame.minY + ((view.frame.maxY - view.frame.minY) / 2)
        let centerViewPoint = CGPoint(x: xOrigin, y: yOrigin)
        scrollPoint = centerViewPoint
        scroll(NSPoint.zero)
    }
    
}

private extension CanvasClipView {
    
    @objc func scrollViewDidScroll() {
        centerClipView = false
        scrollPoint = nil
    }
    
}

public protocol CanvasViewControllerDelegate: class {
    func didZoomIn(magnification: CGFloat)
    func didZoomOut(magnification: CGFloat)
    func didSelect(view: NSView)
}

public class CanvasView: NSView {
    
    // MARK: - Public Variables
    
    /// Size of the canvas.
    public var canvasSize: NSSize = NSSize(width: 5000, height: 5000) {
        didSet {
            canvasClipView.documentView?.frame.size = canvasSize
        }
    }
    
    public var centerPoint: NSPoint {
        let xOrigin = (scrollView.contentView.documentRect.width) / 2
        let yOrigin = (scrollView.contentView.documentRect.height) / 2
        return NSPoint(x: xOrigin, y: yOrigin)
    }
    
    public var documentSubviews: [NSView] {
        return scrollView.contentView.documentView?.subviews ?? []
    }
    
    public weak var delegate: CanvasViewControllerDelegate?
    
    // MARK: - Private Variables
    
    // Infinte ScrollView: https://blog.helftone.com/infinite-nsscrollview/
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView(frame: NSRect.zero)
        scrollView.allowsMagnification = true
        return scrollView
    }()
    
    private lazy var canvasClipView: CanvasClipView = {
        let clipView = CanvasClipView(canvasSize: canvasSize)
        return clipView
    }()
    
    private lazy var commandHandler: CommandHandler = {
        let handler = CommandHandler()
        handler.delegate = self
        return handler
    }()
    
    private let magnificationIncrement: CGFloat = 0.25
    
    // MARK - Overriden Functions
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupView()
    }
    
    // MARK: - Public Functions
    
    public func centerScrollView() {
        canvasClipView.centerDocumentView()
    }
    
    public func scrollToCenter(of view: NSView) {
        canvasClipView.scrollToCenter(of: view)
    }
    
    public func add(view: NSView) {
        scrollView.contentView.documentView?.addSubview(view)
    }
    
    @discardableResult
    public func addLayerView(rect: NSRect, backgroundColor: CGColor? = nil) -> NSView {
        let layerView = NSView(frame: rect)
        if let backgroundColor = backgroundColor {
            layerView.wantsLayer = true
            layerView.layer?.backgroundColor = backgroundColor
        }
        add(view: layerView)
        return layerView
    }
}

// MARK: - Private Functions
private extension CanvasView {
    
    func setupView() {
        setupDesign()
        setupKeyboardEvents()
        setupMouseEvents()
        centerScrollView()
    }
    
    func setupDesign() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: scrollView,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: scrollView,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: scrollView,
                                         attribute: .leading,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: scrollView,
                                         attribute: .trailing,
                                         multiplier: 1,
                                         constant: 0))
        scrollView.contentView = canvasClipView
    }

}

// MARK: - Keyboard Input
extension CanvasView {
    
    public override var acceptsFirstResponder: Bool {
        return true
    }
    
    public override func becomeFirstResponder() -> Bool {
        return true
    }
    
    public override func resignFirstResponder() -> Bool {
        return true
    }
    
    public override func keyDown(with event: NSEvent) {
        commandHandler.keyDown(code: Int(event.keyCode), modifierFlags: event.modifierFlags)
    }
    
    public override func keyUp(with event: NSEvent) {
        commandHandler.keyUp(code: Int(event.keyCode), modifierFlags: event.modifierFlags)
    }
    
    public override func flagsChanged(with event: NSEvent) {
        if event.modifierFlags.rawValue == 256 {
            canvasClipView.blockScrolling = false
        }
    }
 
    private func setupKeyboardEvents() {
        // More information: http://blog.ericd.net/2016/10/10/ios-to-macos-reading-keyboard-input/
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] (event) -> NSEvent? in
            guard let strongSelf = self else {
                return event
            }
            strongSelf.keyUp(with: event)
            return strongSelf.commandHandler.commandActive ? nil : event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] (event) -> NSEvent? in
            guard let strongSelf = self else {
                return event
            }
            strongSelf.keyDown(with: event)
            return strongSelf.commandHandler.commandActive ? nil : event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] (event) -> NSEvent? in
            guard let strongSelf = self else {
                return event
            }
            strongSelf.flagsChanged(with: event)
            return event
        }
    }
    
}

// MARK: - Mouse Input
extension CanvasView {
 
    public override func mouseUp(with event: NSEvent) {
        if let documentView = canvasClipView.documentView {
            // TODO: Consider saving to memory for larger subview trees.
            for subview in documentView.subviews.reversed() {
                let xClickPoint = (event.locationInWindow.x / scrollView.magnification) +
                    canvasClipView.documentVisibleRect.origin.x
                let yClickPoint = (event.locationInWindow.y / scrollView.magnification) +
                    canvasClipView.documentVisibleRect.origin.y
                if subview.frame.contains(CGPoint(x: xClickPoint, y: yClickPoint)) {
                    print(subview.frame)
                    delegate?.didSelect(view: subview)
                    return
                }
            }
        }
    }
    
    public override func scrollWheel(with event: NSEvent) {
        // TODO: Update Command Handler to handle modifier flags.
        let intersectedModifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if Int(intersectedModifierFlags.rawValue) == Int(NSEvent.ModifierFlags.command.rawValue) {
            canvasClipView.blockScrolling = true
            let magnificationIncrement: CGFloat = 0.1
            let deltaThreshold: CGFloat = 5
            if event.deltaY > deltaThreshold {
                canvasClipView.blockScrolling = false
                scrollView.magnification -= magnificationIncrement
            } else if event.deltaY < -deltaThreshold {
                canvasClipView.blockScrolling = false
                scrollView.magnification += magnificationIncrement
            }
        }
    }
    
    func setupMouseEvents() {
        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { [weak self] (event) -> NSEvent? in
            guard let strongSelf = self else {
                return event
            }
            strongSelf.scrollWheel(with: event)
            return event
        }
    }
    
}

// MARK: - CommandHandlerDelegate
extension CanvasView: CommandHandlerDelegate {
    
    func handleKeyboardCommand(_ command: KeyboardCommand) {
        switch command {
        case .centerCanvas:
            // TODO: Animate and update the scroll indicators.
            centerScrollView()
        case .increaseMagnification:
            scrollView.magnification += magnificationIncrement
            delegate?.didZoomIn(magnification: scrollView.magnification)
        case .decreaseMagnification:
            scrollView.magnification -= magnificationIncrement
            delegate?.didZoomOut(magnification: scrollView.magnification)
        }
        print(scrollView.magnification)
    }
    
}
