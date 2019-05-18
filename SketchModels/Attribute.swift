//
//  Attribute.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Attribute: Codable {
	let classString: String?
	let length: Int?
	let location: Bool?
	let attributes: SubAttribute?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case attributes = "attributes"
		case length = "length"
		case location = "location"
	}
}

struct SubAttribute: Codable {
    let mSAttributedStringColorAttribute: MSAttributedStringColorAttribute?
    let mSAttributedStringFontAttribute: MSAttributedStringFontAttribute?
    let mSAttributedStringTextTransformAttribute: Bool?
    let kerning: Double?
    let paragraphStyle: ParagraphStyle?
}

struct SizeAttribute: Codable {
    let name: String
    let size: Int
}
