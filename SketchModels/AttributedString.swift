//
//  AttributedString.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct AttributedString: Codable {
	let classString: String
	let attributes: [Attribute]
	let string: String

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case attributes = "attributes"
		case string = "string"
	}
}
