//
//  ResponseHeaderPipeline.swift
//  Pyxis
//
//  Created by Seth Faxon on 10/25/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

public class ResponseHeaderPipeline: PipelineProtocol {
    var connection: Connection
    
    public required init(connection: Connection) {
        self.connection = connection
    }
    
    public func call() -> Connection {
        self.connection.response.headers["ResponseHeaderPipeline"] = "SomeValue"
        self.connection.response.body = "<html><body><h1>Hello World</h1></body></html>"
        return self.connection
    }
}