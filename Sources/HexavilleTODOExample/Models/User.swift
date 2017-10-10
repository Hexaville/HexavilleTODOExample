//
//  User.swift
//  HexavilleTODOExampleDynamodbMigrator
//
//  Created by Yuki Takei on 2017/07/29.
//

import Foundation

struct User: BaseModel {
    static let tableName = "hexaville_todo_app_example_users"
    
    let id: String
    let name: String
    let avaterUrl: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avaterUrl = "avater_url"
    }
}
