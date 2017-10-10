//
//  StencilCustomFilter.swift
//  HexavilleTODOExamplePackageDescription
//
//  Created by Yuki Takei on 2017/10/10.
//

import Foundation
import Stencil

struct TemplateExtension {
    static let shared = TemplateExtension()
    
    let ext: Extension
    
    init() {
        ext = Extension()
        
        ext.registerFilter("link") { (value: Any?, arguments: [Any?]) in
            guard let value = value as? String else {
                throw TemplateSyntaxError("value should be a String")
            }
            
            switch Configuration.shared.env {
            case .production:
                return "/staging/\(value)"
                
            case .development:
                return value
            }
        }
    }
}
