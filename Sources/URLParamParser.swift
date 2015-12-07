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
        let queryItems = url.characters.split{$0 == "?"}.map(String.init)
        if queryItems.count > 1 {
            let query = queryItems.last
            let queryComponents = query!.characters.split{$0 == "&"}.map(String.init)
            return queryComponents.map { (param:String) -> (String, String) in
                let tokens = param.characters.split{$0 == "="}.map(String.init)
                if tokens.count >= 2 {
                    let key = tokens[0]
                    let value = tokens[1]
                    return (key, value)
                }
                return ("","")
            }
        }
        return []
    }
}
