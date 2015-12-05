//
//  Parser.swift
//  PyxisRouter
//
//  Created by Seth Faxon on 7/24/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

class Parser {
    var lookAhead: Token?
    var iterator: IndexingGenerator<[Token]>?
    
    init(tokens: [Token]) {
        self.iterator = tokens.generate()
        lookAhead = self.iterator?.next()
    }
    
    func step() {
        lookAhead = iterator?.next()
    }
    
    func match(token: Token) -> Bool {
        if let la = self.lookAhead {
            if la == Token.LParen || la == Token.RParen {
                step()
                return true
            }
        }
        return false
    }
    
    func parse() -> Node? {
        var tree: Node?
        
        while let lookAhead = lookAhead {
            if match(Token.LParen) {
                
                if lookAhead == Token.LParen {
                    let optional = self.parse()
                    tree?.addChild(optional!)
                }
                
                if !match(Token.RParen) {
                    print("missing closing RParen")
                }
            } else {
                if nil == tree {
                    tree = Node(token: lookAhead)
                } else {
                    tree?.addChild(Node(token: lookAhead))
                }
                print("calling step")
                step()
            }
        }
        return tree
    }
}
