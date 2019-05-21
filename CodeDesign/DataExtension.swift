//
//  DataExtension.swift
//  CodeDesign
//
//  Created by Jonathan Samudio on 5/18/19.
//  Copyright © 2019 JustBinary. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case network(error: Error)
    case jsonSerialization
    case objectSerialization(reason: String)
    case urlInvalid
}

extension Data {
    
    public func deserializeObject<T: Decodable>(completion: (T?, Error?)->()) {
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: self)
            completion(object, nil)
        } catch {
            completion(nil, NetworkError.objectSerialization(reason: "Object Serialization Failed"))
        }
    }
    
    public func deserializeArray<T: Decodable>(completion: ([T]?, Error?)->()) {
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode([T].self, from: self)
            completion(object, nil)
        } catch {
            completion(nil, NetworkError.objectSerialization(reason: "Array Serialization Failed"))
        }
    }
    
    public func serializeToJsonObject() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        } catch {
            return nil
        }
    }
}
