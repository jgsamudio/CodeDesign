//
//  VerticalRulerDatum.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct VerticalRulerDatum: Codable {
	let classString: String
	let base: Bool
	let guides: [Guide]
	let do_objectID: String?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case base = "base"
		case do_objectID = "do_objectID"
		case guides = "guides"
	}
}
