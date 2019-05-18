//
//  Layer.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Layer: Codable {
	let classString: String
	let booleanOperation: Int
	let clippingMaskMode: Bool
	let do_objectID: String
	let edited: Int
	let exportOptions: ExportOption
	let fixedRadius: Int
	let groupLayout: GroupLayout
	let hasClickThrough: Bool
	let hasClippingMask: Bool
	let hasConvertedToNewRoundCorners: Bool
	let horizontalRulerData: HorizontalRulerDatum?
	let isClosed: Bool
	let isFixedToViewport: Bool?
	let isFlippedHorizontal: Bool
	let isFlippedVertical: Bool
	let isLocked: Bool?
	let isVisible: Bool
	let layerListExpandedType: Bool
	let name: String
	let nameIsFixed: Bool
	let pointRadiusBehaviour: Bool?
	let points: [Point]
	let resizingConstraint: Int
	let resizingType: Bool
	let rotation: Bool
	let sharedStyleID: String
	let shouldBreakMaskChain: Bool
	let style: Style
	let userInfo: UserInfo
	let verticalRulerData: VerticalRulerDatum
	let attributedString: AttributedString?
	let automaticallyDrawOnUnderlyingPath: Bool?
	let dontSynchroniseWithSymbol: Bool?
	let glyphBounds: String?
	let lineSpacingBehaviour: Int?
	let textBehaviour: Bool?
	let layers: [Layer]?
	let frame: Frame?
	let allowsOverrides: Bool?
	let backgroundColor: BackgroundColor?
	let changeIdentifier: Int?
	let hasBackgroundColor: Bool?
	let includeBackgroundColorInExport: Bool?
	let includeBackgroundColorInInstance: Bool?
	let includeInCloudUpload: Bool?
	let isFlowHome: Bool?
	let overrideProperties: [OverridePropertie]?
	let resizesContent: Bool?
	let symbolID: String?
	let horizontalSpacing: Bool?
	let overrideValues: [OverrideValue]?
	let scale: Bool?
	let verticalSpacing: Bool?
	let presetDictionary: PresetDictionary?

	enum CodingKeys: String, CodingKey {
		case classString = "_class"
		case allowsOverrides = "allowsOverrides"
		case attributedString = "attributedString"
		case automaticallyDrawOnUnderlyingPath = "automaticallyDrawOnUnderlyingPath"
		case backgroundColor = "backgroundColor"
		case booleanOperation = "booleanOperation"
		case changeIdentifier = "changeIdentifier"
		case clippingMaskMode = "clippingMaskMode"
		case do_objectID = "do_objectID"
		case dontSynchroniseWithSymbol = "dontSynchroniseWithSymbol"
		case edited = "edited"
		case exportOptions = "exportOptions"
		case fixedRadius = "fixedRadius"
		case frame = "frame"
		case glyphBounds = "glyphBounds"
		case groupLayout = "groupLayout"
		case hasBackgroundColor = "hasBackgroundColor"
		case hasClickThrough = "hasClickThrough"
		case hasClippingMask = "hasClippingMask"
		case hasConvertedToNewRoundCorners = "hasConvertedToNewRoundCorners"
		case horizontalRulerData = "horizontalRulerData"
		case horizontalSpacing = "horizontalSpacing"
		case includeBackgroundColorInExport = "includeBackgroundColorInExport"
		case includeBackgroundColorInInstance = "includeBackgroundColorInInstance"
		case includeInCloudUpload = "includeInCloudUpload"
		case isClosed = "isClosed"
		case isFixedToViewport = "isFixedToViewport"
		case isFlippedHorizontal = "isFlippedHorizontal"
		case isFlippedVertical = "isFlippedVertical"
		case isFlowHome = "isFlowHome"
		case isLocked = "isLocked"
		case isVisible = "isVisible"
		case layerListExpandedType = "layerListExpandedType"
		case layers = "layers"
		case lineSpacingBehaviour = "lineSpacingBehaviour"
		case name = "name"
		case nameIsFixed = "nameIsFixed"
		case overrideProperties = "overrideProperties"
		case overrideValues = "overrideValues"
		case pointRadiusBehaviour = "pointRadiusBehaviour"
		case points = "points"
		case presetDictionary = "presetDictionary"
		case resizesContent = "resizesContent"
		case resizingConstraint = "resizingConstraint"
		case resizingType = "resizingType"
		case rotation = "rotation"
		case scale = "scale"
		case sharedStyleID = "sharedStyleID"
		case shouldBreakMaskChain = "shouldBreakMaskChain"
		case style = "style"
		case symbolID = "symbolID"
		case textBehaviour = "textBehaviour"
		case userInfo = "userInfo"
		case verticalRulerData = "verticalRulerData"
		case verticalSpacing = "verticalSpacing"
	}
}
