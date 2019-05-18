//
//  Point.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Point: Codable {
	let classString: String
	let cornerRadius: Int
	let curveFrom: String
	let curveMode: Bool
	let curveTo: String
	let hasCurveFrom: Bool
	let hasCurveTo: Bool
	let point: String

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case cornerRadius = "cornerRadius"
		case curveFrom = "curveFrom"
		case curveMode = "curveMode"
		case curveTo = "curveTo"
		case hasCurveFrom = "hasCurveFrom"
		case hasCurveTo = "hasCurveTo"
		case point = "point"
	}
}
