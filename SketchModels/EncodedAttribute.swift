//
//  EncodedAttribute.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct EncodedAttribute: Codable {
	let mSAttributedStringColorAttribute: MSAttributedStringColorAttribute
	let mSAttributedStringFontAttribute: MSAttributedStringFontAttribute
	let mSAttributedStringTextTransformAttribute: Bool
	let kerning: Double
	let paragraphStyle: ParagraphStyle

	enum CodingKeys: String, CodingKey {
		case kerning = "kerning"
		case mSAttributedStringColorAttribute = "mSAttributedStringColorAttribute"
		case mSAttributedStringFontAttribute = "mSAttributedStringFontAttribute"
		case mSAttributedStringTextTransformAttribute = "mSAttributedStringTextTransformAttribute"
		case paragraphStyle = "paragraphStyle"
	}
}
