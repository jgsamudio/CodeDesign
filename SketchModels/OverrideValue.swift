//
//  OverrideValue.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct OverrideValue: Codable {
	let classString: String
	let doObjectID: String
	let overrideName: String
	let value: String

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case doObjectID = "do_objectID"
		case overrideName = "overrideName"
		case value = "value"
	}
}
