//
//  Pipeline.swift
//  Pyxis
//
//  Created by Seth Faxon on 10/25/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

public protocol PipelineProtocol {
    init(connection: Connection)
    func call() -> Connection
}

public class ConnectionPipeline {
    
    var pipelineItems: [PipelineProtocol.Type] = []

    public init() { }
    
    public func addPipeline(pipeline: PipelineProtocol.Type) {
        self.pipelineItems.append(pipeline)
    }
    
    public func respond(connection: Connection) -> Connection {
        var next = connection
        for pipeline in self.pipelineItems {
            let ex = pipeline.init(connection: next)
            next = ex.call()
        }
        return next
    }
}

