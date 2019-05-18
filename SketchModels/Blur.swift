//
//  Blur.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Blur: Codable {
	let classString: String
	let center: String
	let isEnabled: Bool
	let motionAngle: Bool
	let radius: Double
	let saturation: Bool
	let type: Bool
	let do_objectID: String?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case center = "center"
		case do_objectID = "do_objectID"
		case isEnabled = "isEnabled"
		case motionAngle = "motionAngle"
		case radius = "radius"
		case saturation = "saturation"
		case type = "type"
	}
}
