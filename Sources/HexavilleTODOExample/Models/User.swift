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
    let avaterURLString: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avaterURLString = "avater_url"
    }
    
    init(id: String, name: String, avaterURLString: String, email: String) {
        self.id = id
        self.name = name
        self.avaterURLString = avaterURLString
        self.email = email
    }
}

#if os(Linux)
    extension User {
        init(fromDictionary dict: [String: Any]) {
            self.id = dict["id"] as! String
            self.name = dict["name"] as! String
            self.email = dict["email"] as! String
            self.avaterURLString = dict["avater_url"] as! String
        }
    }
#endif
