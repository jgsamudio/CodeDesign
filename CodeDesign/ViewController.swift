//
//  ViewController.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    private var designRoot: DesignRoot? {
        didSet {
            print("Design Root Loaded")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseSketchJson()
    }
    
    private func parseSketchJson() {
        let fileToParse = "/Users/jonathansamudio/JustBinaryProjects/CodeDesign/SketchJson/DesignRoot.json"
        
        do {
            let content = try String(contentsOfFile: fileToParse, encoding: String.Encoding.utf8)
            let fileLines = content.components(separatedBy: "\n")
            setupConfigurationFile(fileLines: fileLines)
        } catch {
            print("Error caught with message: \(error.localizedDescription)")
        }
    }
    
    private func setupConfigurationFile(fileLines: [String]) {
        let configString = fileLines.joined()
        let configData = configString.data(using: .utf8)
        configData?.deserializeObject(completion: { (designRoot: DesignRoot?, _) in
            self.designRoot = designRoot
        })
    }
}
