//
//  BaseModel.swift
//  HexavilleTODOExampleDynamodbMigrator
//
//  Created by Yuki Takei on 2017/07/29.
//

import Foundation


#if os(Linux)
    extension String {
        func lowerFirst() -> String {
            return String(self[self.startIndex]).lowercased() + self.substring(from: self.index(after: self.startIndex))
        }
        
        func snakecased() -> String {
            var base = self.lowerFirst()
            let capitalLetterAsciiRanges: CountableRange<UTF8.CodeUnit> = 0x41..<0x5A // A-Z
            var chars = [UInt8]()
            for v in base.utf8 {
                if capitalLetterAsciiRanges.contains(v) {
                    chars.append(0x5F) // _
                    chars.append(v ^ 0x20) // 反転
                } else {
                    chars.append(v)
                }
            }
            return String(bytes: chars, encoding: .utf8) ?? ""
        }
    }


    protocol Encodable2 {}

    enum Decodable2Error: Error {
        case decodeFailed(String)
    }

    protocol Decodable2 {
        init(fromDictionary: [String: Any]) throws
    }

    typealias Codable2 = Encodable2 & Decodable2

    struct JSONEncoder2 {
        func encode(_ encodables: [Encodable2]) throws -> Data {
            var collection: [[String: Any]] = []
            for encodable in encodables {
                var dict: [String: Any] = [:]
                for (label, element) in Mirror(reflecting: encodable).children {
                    dict[label!.snakecased()] = element
                }
                collection.append(dict)
            }
            return try JSONSerialization.data(withJSONObject: collection, options: [])
        }
        
        func encode(_ encodable: Encodable2) throws -> Data {
            var dict: [String: Any] = [:]
            for (label, element) in Mirror(reflecting: encodable).children {
                dict[label!.snakecased()] = element
            }
            return try JSONSerialization.data(withJSONObject: dict, options: [])
        }
    }

    struct JSONDecoder2 {
        func decode<T: Decodable2>(_ type: T.Type, from data: Data) throws -> T {
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            return try type.init(fromDictionary: dict)
        }
    }

    typealias JSONEncoder = JSONEncoder2
    typealias JSONDecoder = JSONDecoder2
    typealias Codable = Codable2
    typealias Decodable = Decodable2
    typealias Encodable = Encodable2
#endif

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
    func decode<T: Codable>() throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
}
