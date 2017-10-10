//
//  Request.swift
//  CHTTPParser
//
//  Created by Yuki Takei on 2017/07/28.
//

import HexavilleFramework

extension ApplicationContext {
    var accessToken: String? {
        return self.session?["token"] as? String
    }
    
    var currentUser: User? {
        do {
            if let user = self.memory["currentUser"] as? User {
                return user
            }
            
            if let dict = session?["currentUser"] as? [String: Any] {
                let user: User = try dict.decode()
                self.memory["currentUser"] = user
                return user
            }
        } catch {
            return nil
        }
        return nil
    }
}
