//
//  CanvasViewDelegate.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/24/19.
//  Copyright © 2019 Prolific Interactive. All rights reserved.
//

import Foundation
import Cocoa

public protocol CanvasViewDelegate: class {
    func didZoomIn(magnification: CGFloat)
    func didZoomOut(magnification: CGFloat)
    func didSelect(view: NSView)
}
