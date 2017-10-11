//
//  Configuration.swift
//  TwitterPostApp
//
//  Created by Yuki Takei on 2017/07/27.
//
//

import Foundation
import HexavilleFramework

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
    
    let env = HexavilleENV(rawValue: ProcessInfo.processInfo.environment["HEXAVILLE_ENV"])
    
    var baseURLString: String {
        return HostResolver.shared.resolveBaseURLString() ?? "http://localhost:3000"
    }
}

enum ConnectionName: Hashable {
    case dybamodb
}
