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

#if os(Linux)
extension TODOText {
    init(fromDictionary: [String : Any]) throws {
        guard let text = fromDictionary["text"] as? String else {
            throw Decodable2Error.decodeFailed("text")
        }
        self.text = text
    }
}
#endif

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

#if os(Linux)
extension TODO {
    init(fromDictionary dictionary: [String : Any]) throws {
        self.id = dictionary["id"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.userId = dictionary["user_id"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
    }
}
#endif
