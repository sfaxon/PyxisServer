//
//  Node.swift
//  PyxisRouter
//
//  Created by Seth Faxon on 7/21/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

class Node: Equatable, CustomStringConvertible {
    typealias Handler = Connection -> Connection

    var children = [Node]()
    let token: Token
    var handler: Handler? = nil

    init(token: Token) {
        self.token = token
    }

    // adds the given child token if it doesn't exist
    // return the existing child, or the newly created node
    func addChild(node: Node) -> Node {
        let index = indexOfTrippleEqualChild(node)
        if index != nil {
            return self.children[index!]
        } else {
            self.children.append(node)
        }
        return node
    }

    func matchingChild(token: Token) -> (Node?, String) {
        print("calling Node.matchingChild(\(token))")
        print("\(self.children)\n")
        for child in self.children {
            let match = child.token.routeMatch(token)
            if match.0 {
                print("!!!matchingChild returning \(child)")
                return (child, match.1)
            }
        }
        print("didn't find matching child node")
        return (nil, "")
    }

    var description: String {
        return "\(self.token) -> \(self.children.count)"
    }

    private func indexOfTrippleEqualChild(node: Node) -> Int? {
        for (index, c) in self.children.enumerate() {
            if node.token === c.token {
                return index
            }
        }
        return nil
    }
}

func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.token == rhs.token
}

