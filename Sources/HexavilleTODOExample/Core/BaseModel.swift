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
}

extension BaseModel {
    func serializeToJSONUTF8Data() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func serializeToJSONString() throws -> String {
        return try String(data: serializeToJSONUTF8Data(), encoding: .utf8) ?? ""
    }
    
    func serializeToDictionary() throws -> [String: Any] {
        let data = try self.serializeToJSONUTF8Data()
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
    }
}

extension Dictionary where Key == String, Value: Any {
    func decode<T: Decodable>() throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
}
