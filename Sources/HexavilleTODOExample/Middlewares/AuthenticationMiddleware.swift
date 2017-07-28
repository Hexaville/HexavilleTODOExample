//
//  AuthenticationMiddleware.swift
//  CHTTPParser
//
//  Created by Yuki Takei on 2017/07/28.
//

import Foundation
import HexavilleFramework
import HexavilleAuth

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
            let error = ErrorMessage(errorCode: nil, errorMessage: "Authorization Required")
            let body = try JSONEncoder().encode(error)
            return .respond(to: Response(status: .unauthorized, body: body))
        } else {
            let data = try AssetLoader.shared.load(fileInAssets: "/html/signin.html")
            return .respond(to: Response(headers: ["Content-Type": "text/html"], body: data))
        }
    }
}
