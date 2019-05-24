//
//  CommandHandler.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/24/19.
//  Copyright © 2019 Prolific Interactive. All rights reserved.
//

import Foundation
import Cocoa

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
