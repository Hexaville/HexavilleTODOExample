//
//  BaseModel.swift
//  HexavilleTODOExampleDynamodbMigrator
//
//  Created by Yuki Takei on 2017/07/29.
//

import Foundation

protocol BaseModel: Codable {
    static var tableName: String { get }
    var id: String { get }
    #if os(Linux)
    init(fromDictionary: [String: Any])
    #endif
}

extension BaseModel {
    func serializeToJSONUTF8Data() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func serializeToJSONString() throws -> String {
        return try String(data: serializeToJSONUTF8Data(), encoding: .utf8) ?? ""
    }
    
    #if os(Linux)
        func serializeToDictionary() throws -> [String : Any] {
            var dict: [String: Any] = [:]
            for (label, element) in Mirror(reflecting: self).children {
                guard let label = label else { continue }
                dict[label] = element
            }
            return dict
        }
    #else
        func serializeToDictionary() throws -> [String: Any] {
            let data = try self.serializeToJSONUTF8Data()
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        }
    #endif
}

extension Dictionary where Key == String, Value: Any {
    func decode<T: Decodable>() throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
}
