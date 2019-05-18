//
//  MSAttributedStringColorAttribute.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct MSAttributedStringColorAttribute: Codable {
	let classString: String?
	let alpha: Double?
	let green: Double?
	let blue: Double?
	let red: Double?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case alpha = "alpha"
		case blue = "blue"
		case green = "green"
		case red = "red"
	}
}
