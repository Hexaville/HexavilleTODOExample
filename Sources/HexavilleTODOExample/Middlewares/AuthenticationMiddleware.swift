//
//  AuthenticationMiddleware.swift
//  CHTTPParser
//
//  Created by Yuki Takei on 2017/07/28.
//

import Foundation
import HexavilleFramework

extension Request {
    func contentTypeIsJSON() -> Bool {
        guard let contentType = self.contentType else { return false }
        return contentType.subtype == "json"
    }
}

struct AuthenticationMiddleware: Middleware {
    func respond(to request: Request, context: ApplicationContext) throws -> Chainer {
        if context.isAuthenticated() {
            return .next(request)
        }
        
        if request.contentTypeIsJSON() {
            return .respond(to: Response(status: .unauthorized, body: "{\"error\": \"Authorization Required\"}"))
        } else {
            let data = try AssetLoader.shared.load(fileInAssets: "/html/signin.html")
            return .respond(to: Response(body: data))
        }
    }
}
