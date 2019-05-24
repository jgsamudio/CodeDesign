//
//  CommandHandlerDelegate.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/24/19.
//  Copyright © 2019 Prolific Interactive. All rights reserved.
//

import Foundation

protocol CommandHandlerDelegate: class {
    
    /// Delegate handler for a received keyboard command.
    ///
    /// - Parameter command: KeyboardCommand type identified as received.
    func handleKeyboardCommand(_ command: KeyboardCommand)
    
}
