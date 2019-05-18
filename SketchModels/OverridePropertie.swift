//
//  OverridePropertie.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct OverridePropertie: Codable {
	let classString: String
	let canOverride: Bool
	let overrideName: String

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case canOverride = "canOverride"
		case overrideName = "overrideName"
	}
}
