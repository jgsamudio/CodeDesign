//
//  Frame.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Frame: Codable {
	let classString: String?
	let constrainProportions: Bool
	let width: Int
	let x: Int
	let y: Int
	let height: Int?
	let doObjectID: String?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case constrainProportions = "constrainProportions"
		case doObjectID = "do_objectID"
		case height = "height"
		case width = "width"
		case x = "x"
		case y = "y"
	}
}
