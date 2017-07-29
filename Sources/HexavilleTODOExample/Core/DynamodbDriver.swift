//
//  DynamodbDriver.swift
//  HexavilleTODOExampleDynamodbMigrator
//
//  Created by Yuki Takei on 2017/07/29.
//

import Foundation
import SwiftAWSDynamodb

struct DynamodbDriver: DBDriver {
    
    private let dynamodb: Dynamodb
    
    init(dynamodb: Dynamodb){
        self.dynamodb = dynamodb
    }
    
    func fetch<Model>() throws -> [Model] where Model : BaseModel {
        let output = try dynamodb.scan(Dynamodb.ScanInput(tableName: Model.tableName))
        return try output.items?.map({
            let dictionary = try DynamoDBAttributeItemDecoder.decode($0)
            return try dictionary.decode()
        }) ?? []
    }
    
    func fetch<Model>(byID id: String) throws -> Model? where Model : BaseModel {
        let key = ["id" : Dynamodb.AttributeValue(s: id)]
        let input = Dynamodb.GetItemInput(key: key, tableName: Model.tableName)
        guard let item = try dynamodb.getItem(input).item else {
            return nil
        }
        let dictionary = try DynamoDBAttributeItemDecoder.decode(item)
        return try dictionary.decode()
    }
    
    func create<Model: BaseModel>(_ model: Model) throws -> Model {
        let item = try DynamoDBAttributeItemEncoder.encode(model)
        let input = Dynamodb.PutItemInput(item: item, tableName: Model.tableName)
        _ = try dynamodb.putItem(input)
        
        return model
    }
    
    func destroy<Model>(_ model: Model) throws where Model : BaseModel {
        let key = ["id" : Dynamodb.AttributeValue(s: model.id)]
        let input = Dynamodb.DeleteItemInput(key: key, tableName: Model.tableName)
        _ = try dynamodb.deleteItem(input)
    }
}

enum DynamoDBAttributeItemEncoderError: Error {
    case unsupportedAttributeType(String)
}

enum DynamoDBAttributeItemDecoderError: Error {
    case unsupportedAttributeType(String)
}

struct DynamoDBAttributeItemEncoder {
    static func encode<T: BaseModel>(_ encodable: T) throws -> [String: Dynamodb.AttributeValue] {
        let serialized = try encodable.serializeToDictionary()
        var item: [String: Dynamodb.AttributeValue] = [:]
        for (key, value) in serialized {
            switch value {
            case let value as String:
                item[key] = Dynamodb.AttributeValue(s: value)
                
            case let value as [String]:
                item[key] = Dynamodb.AttributeValue(sS: value)
                
            case let value as Int:
                item[key] = Dynamodb.AttributeValue(n: "\(value)")
                
            case let value as [Int]:
                item[key] = Dynamodb.AttributeValue(nS: value.map({ "\($0)" }))
                
            case _ as [String: Any]:
                throw DynamoDBAttributeItemEncoderError.unsupportedAttributeType("Map")
                
            case let value as Bool:
                item[key] = Dynamodb.AttributeValue(bOOL: value)
                
            default:
                item[key] = Dynamodb.AttributeValue(s: "\(value)")
            }
        }
        
        return item
    }
}


struct DynamoDBAttributeItemDecoder {
    static func decode(_ rawItem: [String: Dynamodb.AttributeValue]) throws -> [String: Any] {
        var item: [String: Any] = [:]
        for (key, value) in rawItem {
            if let v = value.s {
                item[key] = v
            }
            else if let v = value.n {
                // should care all numeric types
                item[key] = Int(v)!
            }
            else if let v = value.bOOL {
                item[key] = v
            }
            else if let v = value.nS {
                item[key] = v
            }
            else if let v = value.sS {
                // should care all numeric types
                item[key] = v.map({ Int($0)! })
            } else {
                throw DynamoDBAttributeItemDecoderError.unsupportedAttributeType("Map, List, Null, Data")
            }
        }
        
        return item
    }
}
