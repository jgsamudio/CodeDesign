//
//  BackgroundColor.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct BackgroundColor: Codable {
	let classString: String
	let alpha: Double
	let blue: Double
	let green: Double
	let red: Double
	let doObjectID: String?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case alpha = "alpha"
		case blue = "blue"
		case doObjectID = "do_objectID"
		case green = "green"
		case red = "red"
	}
}
