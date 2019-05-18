//
//  HorizontalRulerDatum.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct HorizontalRulerDatum: Codable {
	let classString: String
	let base: Bool
	let guides: [Guide]
	let doObjectID: String?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case base = "base"
		case doObjectID = "do_objectID"
		case guides = "guides"
	}
}
