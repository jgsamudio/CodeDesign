//
//  PresetDictionary.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct PresetDictionary: Codable {
	let allowResizedMatching: Bool
	let height: Int
	let name: String
	let offersLandscapeVariant: Bool
	let width: Int

	enum CodingKeys: String, CodingKey {
		case allowResizedMatching = "allowResizedMatching"
		case height = "height"
		case name = "name"
		case offersLandscapeVariant = "offersLandscapeVariant"
		case width = "width"
	}
}
