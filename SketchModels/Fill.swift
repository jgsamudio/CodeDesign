//
//  Fill.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Fill: Codable {
	let classString: String
	let color: Color
	let fillType: Bool
	let isEnabled: Bool
	let noiseIndex: Bool
	let noiseIntensity: Bool
	let patternFillType: Bool
	let patternTileScale: Bool

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case color = "color"
		case fillType = "fillType"
		case isEnabled = "isEnabled"
		case noiseIndex = "noiseIndex"
		case noiseIntensity = "noiseIntensity"
		case patternFillType = "patternFillType"
		case patternTileScale = "patternTileScale"
	}
}
