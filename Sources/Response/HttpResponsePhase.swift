//
//  HttpResponsePhase.swift
//  Pyxis
//
//  Created by Seth Faxon on 10/25/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

public struct HTTPResponsePhrase {
    
    private let code: Int
    init(code: Int) {
        self.code = code
    }
    
    var lookup: String {
        switch self.code {
        case 200:
            return "OK"
        case 201:
            return "Created"
        case 202:
            return "Accepted"
        case 301:
            return "Moved Permenently"
        case 400:
            return "Bat Request"
        case 401:
            return "Unauthorized"
        case 403:
            return "Forbidden"
        case 404:
            return "Not Found"
        case 500:
            return "Internal Server Error"
        default:
            return "Custom"
        }
    }
    
}
