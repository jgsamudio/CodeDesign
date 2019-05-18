//
//  ExportOption.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct ExportOption: Codable {
	let classString: String
	let exportFormats: [ExportFormat]
	let includedLayerIds: [IncludedLayerId]
	let layerOptions: Bool
	let shouldTrim: Bool
	let doObjectID: String?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case doObjectID = "do_objectID"
		case exportFormats = "exportFormats"
		case includedLayerIds = "includedLayerIds"
		case layerOptions = "layerOptions"
		case shouldTrim = "shouldTrim"
	}
}
