//
//  DBDriver.swift
//  HexavilleTODOExampleDynamodbMigrator
//
//  Created by Yuki Takei on 2017/07/29.
//

import Foundation

protocol DBDriver {
    func fetch<Model: BaseModel>() throws -> [Model]
    func fetch<Model: BaseModel>(byID: String) throws -> Model?
    func create<Model: BaseModel>(_ model: Model) throws -> Model
    func destroy<Model: BaseModel>(_ model: Model) throws
}

struct Connection {
    private let driver: DBDriver
    
    static var shared: [AnyHashable: Connection] = [:]
    
    static func set(_ con: Connection, forKey key: AnyHashable) {
        self.shared[key] = con
    }
    
    static func get(forKey key: AnyHashable) -> Connection? {
        return self.shared[key]
    }
    
    init(driver: DBDriver) {
        self.driver = driver
    }
    
    func fetch<Model: BaseModel>() throws -> [Model] {
        return try driver.fetch()
    }
    
    func fetch<Model: BaseModel>(byID id: String) throws -> Model? {
        return try driver.fetch(byID: id)
    }
    
    func create<Model: BaseModel>(_ model: Model) throws -> Model {
        return try driver.create(model)
    }
    
    func destroy<Model: BaseModel>(_ model: Model) throws {
        return try driver.destroy(model)
    }
}
