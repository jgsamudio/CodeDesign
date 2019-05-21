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
            return [18, 1048848]
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
    
    func keyDown(code: Int, modifierFlag: Int) {
        pressedKeys.insert(code)
        pressedKeys.insert(modifierFlag)
        checkForCommand()
    }
    
    func keyUp(code: Int, modifierFlag: Int) {
        pressedKeys.remove(code)
        pressedKeys.remove(modifierFlag)
        checkForCommand()
    }
    
    func isKeyDown(code: Int, modifierFlag: Int) -> Bool {
        return pressedKeys.contains(code) && pressedKeys.contains(modifierFlag)
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

    override var acceptsFirstResponder: Bool {
        return true
    }
    
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
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        guard !commandHandler.isKeyDown(code: Int(event.keyCode),
                                        modifierFlag: Int(event.modifierFlags.rawValue)) else {
            return
        }
        commandHandler.keyDown(code: Int(event.keyCode), modifierFlag: Int(event.modifierFlags.rawValue))
    }
    
    override func keyUp(with event: NSEvent) {
        guard commandHandler.isKeyDown(code: Int(event.keyCode), modifierFlag: Int(event.modifierFlags.rawValue)) else {
            return
        }
        commandHandler.keyUp(code: Int(event.keyCode), modifierFlag: Int(event.modifierFlags.rawValue))
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

extension CanvasViewController: CommandHandlerDelegate {
    
    func handleKeyboardCommand(_ command: KeyboardCommand) {
        switch command {
        case .centerCanvas:
            // TODO: Animate and update the scroll indicators.
            centerScrollView()
        }
    }
}
