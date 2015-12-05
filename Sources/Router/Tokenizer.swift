//
//  Tokenizer.swift
//  PyxisRouter
//
//  Created by Seth Faxon on 7/21/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//


enum Token: CustomStringConvertible {
    case Slash
    case Literal(String)
    case Symbol(String)
    case LParen
    case RParen
    case Dot
    case Star
    case Or
    
    var description: String {
        switch self {
        case .Slash:
            return "/"
        case .Literal(let value):
            return "LITERAL: \(value)"
        case .Symbol(let value):
            return "SYMBOL: \(value)"
        case .LParen:
            return "("
        case .RParen:
            return ")"
        case .Dot:
            return "."
        case .Star:
            return "*"
        case .Or:
            return "|"
        }
    }
    
    var value: String {
        switch self {
        case .Literal(let value):
            return value
        case .Symbol(let value):
            return value
        default:
            return ""
        }
    }
    
    func routeMatch(token: Token) -> (Bool, String) {
        switch self {
        case .Literal(let lValue):
            switch token {
            case .Literal(let rValue):
                if lValue == rValue {
                    return (true, "")
                }
            default:
                return (false, "")
            }
        case .Symbol(let lValue):
            switch token {
            case .Literal(_):
                return (true, lValue)
            default:
                return (false, "")
            }
        default:
            break
        }
        return (false, "")
    }
}

func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.Literal(_), .Literal(_)):
        return true
    case (.Symbol(_), .Symbol(_)):
        return true
    case (.Slash, .Slash):
        return true
    case (.LParen, .LParen):
        return true
    case (.RParen, .RParen):
        return true
    case (.Dot, .Dot):
        return true
    case (.Star, .Star):
        return true
    case (.Or, .Or):
        return true
    default:
        return false
    }
}

func ===(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.Literal(let la), .Literal(let ra)):
        return la == ra
    case (.Symbol(let la), .Symbol(let ra)):
        return la == ra
    case (.Slash, .Slash):
        return true
    case (.LParen, .LParen):
        return true
    case (.RParen, .RParen):
        return true
    case (.Dot, .Dot):
        return true
    case (.Star, .Star):
        return true
    case (.Or, .Or):
        return true
    default:
        return false
    }
}

struct Tokenizer {
    let input:String
    private let terminatorChar = Character("🙈")
    
    init(input: String) {
        self.input = input + String(terminatorChar)
    }
    
    /// Only return literals and symbols
    var pathTokens: [Token] {
        var result = [Token]()
        for token in self.tokens {
            switch token {
            case .Literal(let string):
                result.append(.Literal(string))
            default: break
            }
        }
        return result
    }
    
    var tokens: [Token] {
        let seperatorCharacters: [Character] = [" ", "/", ":", ".", "*", "|", "(", ")", terminatorChar]
        var result = [Token]()
        var token = [Character]()
        
        var chompingLiteral = false
        var chompingSymbol = false
        
        for character in self.input.characters {
            if seperatorCharacters.indexOf(character) != nil && token.count > 0 {
                let t = String(token)
                if chompingSymbol {
                    var symbol = t
                    symbol.removeAtIndex(symbol.startIndex)
                    result.append(Token.Symbol(symbol))
                } else {
                    result.append(Token.Literal(t))
                }
                // reset
                chompingLiteral = false
                chompingSymbol  = false
                token.removeAll()
            }
            
            if character == Character("/") {
                result.append(Token.Slash)
            } else if character == Character("(") {
                result.append(Token.LParen)
            } else if character == Character(")") {
                result.append(Token.RParen)
            } else if character == Character(".") {
                result.append(Token.Dot)
            } else if character == Character("*") {
                result.append(Token.Star)
            } else if character == Character("|") {
                result.append(Token.Or)
            } else if seperatorCharacters.indexOf(character) == nil {
                token.append(character)
            } else {
                chompingLiteral = true
                if character == Character(":") {
                    chompingSymbol = true
                }
                token.append(character)
            }
        }
        return result
    }
    
}
