//
//  ErrorMessage.swift
//  HexavilleTODOExampleDynamodbMigrator
//
//  Created by Yuki Takei on 2017/07/29.
//

import Foundation

struct ErrorMessage: Codable {
    let errorCode: Int?
    let errorMessage: String
}

#if os(Linux)
extension ErrorMessage {
    init(fromDictionary: [String : Any]) throws {
        self.errorCode = fromDictionary["errorCode"] as? Int
        self.errorMessage = fromDictionary["errorMessage"] as? String ?? ""
    }
}
#endif
