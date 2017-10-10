//
//  AuthenticationMiddleware.swift
//  CHTTPParser
//
//  Created by Yuki Takei on 2017/07/28.
//

import Foundation
import HexavilleFramework
import HexavilleAuth
import Stencil

enum HTTPContentType {
    case json
    case html
    case xml
}

extension Request {
    func contentType(is type: HTTPContentType) -> Bool {
        guard let contentType = self.contentType else { return false }
        
        switch type {
        case .json:
            return contentType.subtype == "json"
            
        case .html:
            return contentType.subtype == "html"
            
        case .xml:
            return contentType.subtype == "xml"
        }
    }
}

struct AuthenticationMiddleware: Middleware {
    func respond(to request: Request, context: ApplicationContext) throws -> Chainer {
        if context.isAuthenticated() {
            return .next(request)
        }
        
        if request.contentType(is: .json) {
            let error = ErrorMessage(errorCode: nil, errorMessage: "Authorization Required")
            let body = try JSONEncoder().encode(error)
            return .respond(to: Response(status: .unauthorized, body: body))
        } else {
            let data = try AssetLoader.shared.load(fileInAssets: "/html/signin.html")
            let environment = Environment(extensions: [TemplateExtension.shared.ext])
            let rendered = try environment.renderTemplate(string: String(data: data, encoding: .utf8) ?? "")
            return .respond(to: Response(headers: ["Content-Type": "text/html"], body: rendered))
        }
    }
}
