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
    
    static func command(from keys: Set<Int>) -> KeyboardCommand? {
        for command in KeyboardCommand.allCases {
            if command.commandKeys() == keys {
                return command
            }
        }
        return nil
    }
    
    func commandKeys() -> Set<Int> {
        switch self {
        case .centerCanvas:
            return [18, Int(NSEvent.ModifierFlags.command.rawValue)]
        }
    }
}

protocol CommandHandlerDelegate: class {
    func handleKeyboardCommand(_ command: KeyboardCommand)
}

class CommandHandler {
    
    weak var delegate: CommandHandlerDelegate?
    
    var commandActive: Bool {
        return KeyboardCommand.command(from: pressedKeys) != nil
    }
    
    private var pressedKeys = Set<Int>()
    
    func keyDown(code: Int, modifierFlags: NSEvent.ModifierFlags) {
        let intersectedModifierFlags = modifierFlags.intersection(.deviceIndependentFlagsMask)
        print(pressedKeys)
        pressedKeys.insert(Int(intersectedModifierFlags.rawValue))
        pressedKeys.insert(code)
        checkForCommand()
    }
    
    func keyUp(code: Int, modifierFlags: NSEvent.ModifierFlags) {
        let intersectedModifierFlags = modifierFlags.intersection(.deviceIndependentFlagsMask)
        pressedKeys.remove(Int(intersectedModifierFlags.rawValue))
        pressedKeys.remove(code)
        print(pressedKeys)
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

class CanvasViewController: NSViewController {
    
    // MARK: - Public Variables
    
    /// Size of the canvas.
    var canvasSize: NSSize = NSSize(width: 5000, height: 5000) {
        didSet {
            canvasView?.frame.size = canvasSize
        }
    }
    
    // MARK: - Private Variables
    
    private let scrollView = NSScrollView(frame: NSRect.zero)
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
    
    private var canvasView: NSView? {
        return scrollView.contentView.documentView
    }
    
    // MARK - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupKeyboardEvents()
        
        let sampleView = NSView(frame: NSRect(x: centerPoint.x, y: centerPoint.y, width: 200, height: 200))
        sampleView.wantsLayer = true
        sampleView.layer?.backgroundColor = CGColor.white
        add(view: sampleView)
        scrollTo(view: sampleView)
    }
    
    // MARK: - Public Functions
    
    func centerScrollView() {
        scrollView.contentView.scroll(to: centerPoint)
    }
    
    func scrollTo(view: NSView) {
        let xOrigin = view.frame.minX + ((view.frame.maxX - view.frame.minX) / 2)
        let yOrigin = view.frame.minY + ((view.frame.maxY - view.frame.minY) / 2)
        let centerViewPoint = CGPoint(x: xOrigin, y: yOrigin)
        scrollView.contentView.scroll(to: centerViewPoint)
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
        scrollView.contentView.documentView = NSView(frame: NSRect(origin: CGPoint.zero, size: canvasSize))
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
 
    func setupKeyboardEvents() {
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
