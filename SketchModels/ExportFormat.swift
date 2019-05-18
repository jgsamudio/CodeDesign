//
//  ExportFormat.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct ExportFormat: Codable {
	let classString: String?
	let absoluteSize: Bool?
	let fileFormat: String?
	let name: String?
	let namingScheme: Bool?
	let scale: Bool?
	let visibleScaleType: Bool?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case absoluteSize = "absoluteSize"
		case fileFormat = "fileFormat"
		case name = "name"
		case namingScheme = "namingScheme"
		case scale = "scale"
		case visibleScaleType = "visibleScaleType"
	}
}
