//
//  KeyboardCommand.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/24/19.
//  Copyright © 2019 Prolific Interactive. All rights reserved.
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
