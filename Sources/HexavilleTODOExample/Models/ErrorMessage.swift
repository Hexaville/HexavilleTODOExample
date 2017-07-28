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
