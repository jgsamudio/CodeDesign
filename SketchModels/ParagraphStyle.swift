//
//  ParagraphStyle.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct ParagraphStyle: Codable {
	let classString: String
	let alignment: Int
	let allowsDefaultTighteningForTruncation: Int
	let maximumLineHeight: Int
	let minimumLineHeight: Int

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case alignment = "alignment"
		case allowsDefaultTighteningForTruncation = "allowsDefaultTighteningForTruncation"
		case maximumLineHeight = "maximumLineHeight"
		case minimumLineHeight = "minimumLineHeight"
	}
}
