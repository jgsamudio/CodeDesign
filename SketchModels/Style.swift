//
//  Style.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Style: Codable {
	let classString: String
	let endMarkerType: Bool
	let miterLimit: Int
	let startMarkerType: Bool
	let windingRule: Bool
	let fills: [Fill]?
	let blur: Blur?
	let textStyle: TextStyle?
	let doObjectID: String?
	let borders: [Border]?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case blur = "blur"
		case borders = "borders"
		case doObjectID = "do_objectID"
		case endMarkerType = "endMarkerType"
		case fills = "fills"
		case miterLimit = "miterLimit"
		case startMarkerType = "startMarkerType"
		case textStyle = "textStyle"
		case windingRule = "windingRule"
	}
}
