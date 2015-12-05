//
//  Connection.swift
//  Pyxis
//
//  Created by Seth Faxon on 10/25/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//


public struct Connection {
    public var request: HttpRequest
    public var response: HttpResponseProtocol
    
//    var state = 0
//    var processingParams: [String: Any]
    public var urlParams: [(String, String)] = []
    
    public init(request: HttpRequest) {
        self.request = request
        self.response = HttpResponse()
    }
    
    // func halt() -> sends response
}

