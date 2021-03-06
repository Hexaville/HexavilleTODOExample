//
//  Todo.swift
//  HexavilleTODOExampleDynamodbMigrator
//
//  Created by Yuki Takei on 2017/07/29.
//

import Foundation

struct TODOText: Codable {
    let text: String
}

struct TODO: BaseModel {
    static let tableName = "hexaville_todo_app_example_todos"
    
    var id: String
    
    var text: String
    
    var userId: String
    
    var timestamp: Int
    
    init(id: String = UUID().uuidString, text: TODOText, user: User) {
        self.init(id: id, text: text.text, user: user)
    }
    
    init(id: String = UUID().uuidString, text: String, user: User) {
        self.id = id
        self.text = text
        self.userId = user.id
        self.timestamp = Int(Date().timeIntervalSince1970)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case text
        case timestamp
    }
}
