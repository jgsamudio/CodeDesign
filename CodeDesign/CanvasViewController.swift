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
    
    private var centerClipView = false
    private var scrollPoint: NSPoint?
    
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
        
        if centerClipView {
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

class CanvasViewController: NSViewController {
    
    // MARK: - Public Variables
    
    /// Size of the canvas.
    var canvasSize: NSSize = NSSize(width: 5000, height: 5000) {
        didSet {
            canvasClipView.documentView?.frame.size = canvasSize
        }
    }
    
    // MARK: - Private Variables
    
    // Infinte ScrollView: https://blog.helftone.com/infinite-nsscrollview/
    private let scrollView = NSScrollView(frame: NSRect.zero)
    private lazy var canvasClipView: CanvasClipView = CanvasClipView(canvasSize: canvasSize)
    
    private lazy var commandHandler: CommandHandler = {
        let handler = CommandHandler()
        handler.delegate = self
        return handler
    }()
    
    private var centerPoint: NSPoint {
        let xOrigin = (scrollView.contentView.documentRect.width) / 2
        let yOrigin = (scrollView.contentView.documentRect.height) / 2
        return NSPoint(x: xOrigin, y: yOrigin)
    }
    
    // MARK - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupKeyboardEvents()
        
        // TODO: Remove from view did load.
        let sampleView = NSView(frame: NSRect(x: centerPoint.x-100, y: centerPoint.y-100, width: 200, height: 200))
        sampleView.wantsLayer = true
        sampleView.layer?.backgroundColor = CGColor.white
        add(view: sampleView)
        
        canvasClipView.scrollToCenter(of: sampleView)
    }
    
    // MARK: - Public Functions
    
    func centerScrollView() {
        canvasClipView.centerDocumentView()
    }
    
    func scrollToCenter(of view: NSView) {
        canvasClipView.scrollToCenter(of: view)
    }
    
    func add(view: NSView) {
        scrollView.contentView.documentView?.addSubview(view)
    }
}

// MARK: - Private Functions
private extension CanvasViewController {
    
    func setupDesign() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        
        view.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: scrollView,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view,
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
extension CanvasViewController {
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        commandHandler.keyDown(code: Int(event.keyCode), modifierFlags: event.modifierFlags)
    }
    
    override func keyUp(with event: NSEvent) {
        commandHandler.keyUp(code: Int(event.keyCode), modifierFlags: event.modifierFlags)
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
    }
    
}

// MARK: - CommandHandlerDelegate
extension CanvasViewController: CommandHandlerDelegate {
    
    func handleKeyboardCommand(_ command: KeyboardCommand) {
        switch command {
        case .centerCanvas:
            // TODO: Animate and update the scroll indicators.
            centerScrollView()
        }
    }
}
