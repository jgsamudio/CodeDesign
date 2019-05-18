//
//  Border.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Border: Codable {
	let classString: String
	let color: Color
	let fillType: Bool
	let isEnabled: Bool
	let position: Bool
	let thickness: Bool

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case color = "color"
		case fillType = "fillType"
		case isEnabled = "isEnabled"
		case position = "position"
		case thickness = "thickness"
	}
}
