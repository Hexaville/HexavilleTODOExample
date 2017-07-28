//
//  Configuration.swift
//  TwitterPostApp
//
//  Created by Yuki Takei on 2017/07/27.
//
//

import Foundation

enum HexavilleENV {
    case production
    case development
    
    init(rawValue: String?) {
        guard let rawValue = rawValue else {
            self = .development
            return
        }
        
        switch rawValue {
        case "production":
            self = .production
            
        default:
            self = .development
        }
    }
    
    func isProduction() -> Bool {
        if case .production = self { return true }
        return false
    }
}

struct Configuration {
    static let shared = Configuration()
    
    let env: HexavilleENV
    
    let baseURLString: String
    
    init(){
        env = HexavilleENV(rawValue: ProcessInfo.processInfo.environment["HEXAVILLE_ENV"])
        switch env {
        case .production:
            guard let baseURL = ProcessInfo.processInfo.environment["HEXAVILLE_BASE_URL"] else {
                fatalError("HEXAVILLE_BASE_URL is required in .env")
            }
            baseURLString = baseURL
            
        case .development:
            baseURLString = "http://localhost:3000"
        }
    }
}

enum ConnectionName: Hashable {
    case dybamodb
}
