//
//  HTTPParser.swift
//  PyxisEchoC
//
//  Created by Seth Faxon on 6/28/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

enum HTTPParserError: ErrorType {
    case Generic
    case NextLineParse
    case NextBody
    case InvalidRequest(String)
}

class HttpParser {
    
    func nextHttpRequest(socket: CInt) throws -> HttpRequest? {
        do {
            if let statusLine = try nextLine(socket) {
                let statusTokens = statusLine.componentsSeparatedByString(" ")
//                print("statusTokens: \(statusTokens)")
                if ( statusTokens.count < 3 ) {
                    throw HTTPParserError.Generic
                }
                guard let method = HttpMethod(rawValue: statusTokens[0]) else {
                    throw HTTPParserError.InvalidRequest("Unknown Request \(statusTokens.first)")
                }
                
                let path = statusTokens[1]
                if let headers = try nextHeaders(socket) {
                    // TODO detect content-type and handle:
                    // 'application/x-www-form-urlencoded' -> Dictionary
                    // 'multipart' -> Dictionary
                    if let contentLength = headers["content-length"], let contentLengthValue = Int(contentLength) {
                        let body = try nextBody(socket, size: contentLengthValue)
                        return HttpRequest(method: method, url: path, headers: headers, body: body)
                    }

                    return HttpRequest(method: method, url: path, headers: headers, body: nil)
                }
            }
        } catch {
            throw HTTPParserError.Generic
        }
        return nil
    }
    
    private func nextBody(socket: CInt, size: Int) throws -> String? {
        var body = ""
        var counter = 0;
        while ( counter < size ) {
            let c = nextInt8(socket)
            if ( c < 0 ) {
                throw HTTPParserError.NextBody
            }
            body.append(UnicodeScalar(c))
            counter++;
        }
        return body
    }
    
    private func nextHeaders(socket: CInt) throws -> Dictionary<String, String>? {
        var headers = Dictionary<String, String>()
        do {
            while let headerLine = try nextLine(socket) {
                if ( headerLine.isEmpty ) {
                    return headers
                }
                let headerTokens = headerLine.componentsSeparatedByString(":")
                if ( headerTokens.count >= 2 ) {
                    // RFC 2616 - "Hypertext Transfer Protocol -- HTTP/1.1", paragraph 4.2, "Message Headers":
                    // "Each header field consists of a name followed by a colon (":") and the field value. Field names are case-insensitive."
                    // We can keep lower case version.
                    let headerName = headerTokens[0].lowercaseString
                    let headerValue = headerTokens[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if ( !headerName.isEmpty && !headerValue.isEmpty ) {
                        headers.updateValue(headerValue, forKey: headerName)
                    }
                }
            }
        } catch {
            throw HTTPParserError.NextLineParse
        }
        
        return nil
    }
    
    private func nextInt8(socket: CInt) -> Int {
        var buffer = [UInt8](count: 1, repeatedValue: 0);
        let next = recv(socket as Int32, &buffer, Int(buffer.count), 0)
        if next <= 0 { return next }
        return Int(buffer[0])
    }
    
    private func nextLine(socket: CInt) throws -> String? {
        var characters: String = ""
        var n = 0
        repeat {
            n = nextInt8(socket)
            if ( n > 13 /* CR */ ) { characters.append(Character(UnicodeScalar(n))) }
        } while ( n > 0 && n != 10 /* NL */)
        if ( n == -1 && characters.isEmpty ) {
            throw HTTPParserError.NextLineParse
        }
        return characters
    }
    
    func supportsKeepAlive(headers: Dictionary<String, String>) -> Bool {
        if let value = headers["connection"] {
            return "keep-alive" == value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).lowercaseString
        }
        return false
    }
}
