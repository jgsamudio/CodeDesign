//
//  CanvasClipView.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/24/19.
//  Copyright © 2019 Prolific Interactive. All rights reserved.
//

import Foundation
import Cocoa

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
