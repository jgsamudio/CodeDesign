//
//  UserInfo.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 05/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct UserInfo: Codable {
    let sketchPlugin: SketchPlugin

	enum CodingKeys: String, CodingKey {
		case sketchPlugin = "com.animaapp.stc-sketch-plugin"
	}
}
