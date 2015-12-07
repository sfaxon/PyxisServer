//
//  TreeBuilder.swift
//  PyxisRouter
//
//  Created by Seth Faxon on 7/21/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

class RouteTree: CustomStringConvertible {
    typealias Handler = Connection -> Connection
    
    var rootNode: Node
    init() {
        self.rootNode = Node(token: Token.Slash)
    }
    
    func rootNode(handler: Handler) {
        self.rootNode.handler = handler
    }
    
    func addTokens(tokens: [Token], forHandler: Handler) {
        var currentNode = self.rootNode
        currentNode.handler = forHandler
        print("\naddTokens:")
        for (index, t) in tokens.enumerate() {
            let tokenNode = Node(token: t)
            print("index: \(index), t = \(t), currentNode.token = \(currentNode.token)")
            if tokenNode != self.rootNode {
                currentNode = currentNode.addChild(tokenNode)
            }
            if index + 1 == tokens.count {
                print("tokenNode.handler = \(forHandler)")
                tokenNode.handler = forHandler
            }
        }
    }
    
    var description: String {
        return "\(self.rootNode.children.map { $0.description })"
    }
    
    func findHandler(handler: Connection) -> (Handler)? {
        let request = handler.request
        let pathSplit = request.url.characters.split{$0 == "?"}.map(String.init)
        let requestTokens = Tokenizer.init(input: pathSplit[0])
        var currentNode: Node? = self.rootNode
//        let mutatableRequest = request
        
        print("currentNode (root): \(currentNode!)")
        for (index, token) in requestTokens.pathTokens.enumerate() {
            print("index: \(index) is \(token)")
            if let cn = currentNode {
                print("calling matchingChild")
                let nodeString = cn.matchingChild(token)
                currentNode = nodeString.0
//                if nodeString.1 != "" {
//                    mutatableRequest.urlParams.append((nodeString.1, token.value))
//                }
                print("currentNode: \(currentNode)")
            } else {
                print("returning root node handler")
                if let hndl = rootNode.handler {
                    return hndl
                } else {
                    // should be 404
                    return nil
                }
            }
            
            print("index: \(index) - tokenCount: \(requestTokens.tokens.count)")
            if index + 1 == requestTokens.pathTokens.count {
                print("found handler: \(currentNode?.handler)")
//                return request -> HttpResponse
                if let hndl = currentNode?.handler {
                    print("returning hndl: \(hndl)")
                    return hndl
                }
            }
        }
        return nil // 404
    }
    
}
