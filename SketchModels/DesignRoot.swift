//
//  AECE0FB3-6A2B-46B4-A3E3-44EB64B4EF7E.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct DesignRoot: Codable {
	let classString: String
	let booleanOperation: Int
	let clippingMaskMode: Bool
	let doObjectID: String
	let exportOptions: ExportOption
	let frame: Frame
	let groupLayout: GroupLayout
	let hasClickThrough: Bool
	let hasClippingMask: Bool
	let horizontalRulerData: HorizontalRulerDatum
	let includeInCloudUpload: Bool
	let isFixedToViewport: Bool
	let isFlippedHorizontal: Bool
	let isFlippedVertical: Bool
	let isLocked: Bool
	let isVisible: Bool
	let layerListExpandedType: Bool
	let layers: [Layer]
	let name: String
	let nameIsFixed: Bool
	let resizingConstraint: Int
	let resizingType: Bool
	let rotation: Bool
	let shouldBreakMaskChain: Bool
	let style: Style
	let verticalRulerData: VerticalRulerDatum

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case booleanOperation = "booleanOperation"
		case clippingMaskMode = "clippingMaskMode"
		case doObjectID = "do_objectID"
		case exportOptions = "exportOptions"
		case frame = "frame"
		case groupLayout = "groupLayout"
		case hasClickThrough = "hasClickThrough"
		case hasClippingMask = "hasClippingMask"
		case horizontalRulerData = "horizontalRulerData"
		case includeInCloudUpload = "includeInCloudUpload"
		case isFixedToViewport = "isFixedToViewport"
		case isFlippedHorizontal = "isFlippedHorizontal"
		case isFlippedVertical = "isFlippedVertical"
		case isLocked = "isLocked"
		case isVisible = "isVisible"
		case layerListExpandedType = "layerListExpandedType"
		case layers = "layers"
		case name = "name"
		case nameIsFixed = "nameIsFixed"
		case resizingConstraint = "resizingConstraint"
		case resizingType = "resizingType"
		case rotation = "rotation"
		case shouldBreakMaskChain = "shouldBreakMaskChain"
		case style = "style"
		case verticalRulerData = "verticalRulerData"
	}
}
