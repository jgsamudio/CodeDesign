//
//  TextStyle.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct TextStyle: Codable {
	let classString: String
	let encodedAttributes: EncodedAttribute
	let verticalAlignment: Bool
	let doObjectID: String?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case doObjectID = "do_objectID"
		case encodedAttributes = "encodedAttributes"
		case verticalAlignment = "verticalAlignment"
	}
}
