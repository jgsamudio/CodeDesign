//
//  CanvasViewController.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/20/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//
import Foundation
import Cocoa

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
    
    public weak var delegate: CanvasViewDelegate?
    
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
    
    public func resetCanvas() {
        scrollView.contentView.documentView?.subviews.forEach { $0.removeFromSuperview() }
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
    
    func applyTestView() {
        let view = addLayerView(rect: NSRect(x: 100, y: 100, width: 200, height: 200), backgroundColor: CGColor.black)
        let subview = NSView(frame: NSRect(x: 100, y: 100, width: 50, height: 50))
        subview.wantsLayer = true
        subview.layer?.backgroundColor = CGColor.white
        view.addSubview(subview)
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
            let xClickPoint = (event.locationInWindow.x / scrollView.magnification) +
                canvasClipView.documentVisibleRect.origin.x
            let yClickPoint = (event.locationInWindow.y / scrollView.magnification) +
                canvasClipView.documentVisibleRect.origin.y
            let selectedPoint = CGPoint(x: xClickPoint, y: yClickPoint)
            
            if let view = viewSelected(point: selectedPoint, subviews: documentView.subviews) {
                print(view.frame)
                delegate?.didSelect(view: view)
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
    
    func viewSelected(point: CGPoint, subviews: [NSView]) -> NSView? {
        for subview in subviews.reversed() {
            if subview.frame.contains(point) {
                if !subview.subviews.isEmpty {
                    let adjustedPoint = CGPoint(x: abs(point.x - subview.frame.origin.x),
                                                y: abs(point.y - subview.frame.origin.y))
                    let childView = viewSelected(point: adjustedPoint, subviews: subview.subviews)
                    return childView == nil ? subview : childView
                }
                return subview
            }
        }
        return nil
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
