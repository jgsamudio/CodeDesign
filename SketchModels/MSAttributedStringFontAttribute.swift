//
//  MSAttributedStringFontAttribute.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct MSAttributedStringFontAttribute: Codable {
	let classString: String
	let sizeAttribute: SizeAttribute

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case sizeAttribute = "attributes"
	}
}
