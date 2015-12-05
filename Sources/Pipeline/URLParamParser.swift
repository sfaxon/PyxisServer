//
//  URLParamParser.swift
//  Pyxis
//
//  Created by Seth Faxon on 10/26/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

import Foundation

public class URLParamParser: PipelineProtocol {
    private var connection: Connection
    
    public required init(connection: Connection) {
        self.connection = connection
    }
    
    public func call() -> Connection {
        self.connection.urlParams = extractUrlParams(connection.request.url)
        return self.connection
    }
    
    private func extractUrlParams(url: String) -> [(String, String)] {
        if let query = url.componentsSeparatedByString("?").last {
            return query.componentsSeparatedByString("&").map { (param:String) -> (String, String) in
                let tokens = param.componentsSeparatedByString("=")
                if tokens.count >= 2 {
                    let key = tokens[0].stringByRemovingPercentEncoding
                    let value = tokens[1].stringByRemovingPercentEncoding
                    if key != nil && value != nil { return (key!, value!) }
                }
                return ("","")
            }
        }
        return []
    }
}