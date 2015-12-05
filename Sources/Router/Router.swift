//
//  Router.swift
//  PyxisRouter
//
//  Created by Seth Faxon on 8/23/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

public class Router {
    public typealias Handler = Connection -> Connection

    let getTree = RouteTree()
    let putTree = RouteTree()
    let postTree = RouteTree()
    let deleteTree = RouteTree()
    
    public init() {
        
    }
    
    public func add(methods: [HttpMethod], path: String, responder: Handler) {
        for method in methods {
            add(method, path: path, responder: responder)
        }
    }
    
    public func add(method: HttpMethod, path: String, responder: Handler) {
        let t = Tokenizer.init(input: path)
        
        switch method {
        case .Get:
            getTree.addTokens(t.tokens, forHandler: responder)
        case .Put:
            putTree.addTokens(t.tokens, forHandler: responder)
        case .Post:
            postTree.addTokens(t.tokens, forHandler: responder)
        case .Delete:
            deleteTree.addTokens(t.tokens, forHandler: responder)
        default:
            break
        }
    }
    
    public func findHandler(connection: Connection) -> Handler {
        print("calling Router.findHandler")
        if let handler = getTree.findHandler(connection) {
            return handler
        }
        var responseConnection = Connection(request: connection.request)
        
        responseConnection.response = SimpleResponse.NotFound
//        let handler: Handler = connection -> responseConnection
        return { (connection) in { return responseConnection }() }
    }

    
//    public func get(path: String, handler: Handler) {
//        let t = Tokenizer(input: path)
//        print("get(\(path))")
//        getTree.addTokens(t.tokens, forHandler: handler)
//    }
//    
//    public func root(handler: Handler) {
//        getTree.rootNode(handler)
//    }
//    
//    public func routes() -> [String] {
//        return []
//    }
//    
//    public func findHandler(request:HttpRequest) -> (handler: Handler, mutatedRequest: HttpRequest) {
//        var response: (Handler?, HttpRequest) = (nil, request)
//        switch request.method {
//        case .Get:
//            if let responder = getTree.findHandler(request) {
//                response.0 = responder.0
//                response.1 = responder.1
//            }
//        default:
//            break
//        }
//        
//        if let h = response.0 {
//            return (h, response.1)
//        } else {
//            return ({ (request) -> HttpResponse in
//                return SimpleResponse.NotFound("<h1>404</h1>")
//            }, request)
//        }
////        let matchingRoutes = self.handlers.filter {
////            $0.0.numberOfMatchesInString(url, options: self.matchingOptions, range: HttpServer.asciiRange(url)) > 0
////        }
////        if let responseFunction: (NSRegularExpression, Handler) = matchingRoutes.last {
////            return responseFunction
////        } else {
////            return nil
////        }
//    }
}
