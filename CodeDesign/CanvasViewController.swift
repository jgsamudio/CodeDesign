//
//  CanvasViewController.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/20/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

import Foundation
import Cocoa

class CanvasViewController: NSViewController {
    
    /// Size of the canvas.
    var canvasSize: NSSize = NSSize(width: 5000, height: 5000) {
        didSet {
            canvasView?.frame.size = canvasSize
        }
    }
    
    private let scrollView = NSScrollView(frame: NSRect.zero)
    
    private var centerPoint: NSPoint {
        let xOrigin = (scrollView.contentView.documentRect.width) / 2
        let yOrigin = (scrollView.contentView.documentRect.height) / 2
        return NSPoint(x: xOrigin, y: yOrigin)
    }
    
    private var canvasView: NSView? {
        return scrollView.contentView.documentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        
        let sampleView = NSView(frame: NSRect(x: centerPoint.x, y: centerPoint.y, width: 200, height: 200))
        sampleView.wantsLayer = true
        sampleView.layer?.backgroundColor = CGColor.white
        add(view: sampleView)
        
        scrollTo(view: sampleView)
    }
    
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
    
}
