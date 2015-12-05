//
//  HttpSimpleResponse.swift
//  Pyxis
//
//  Created by Seth Faxon on 10/25/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

public struct SimpleResponse: HttpResponseProtocol {
//    case OK(String), Created, Accepted
//    case MovedPermanently(String)
//    case BadRequest, Unauthorized, Forbidden
//    case NotFound(String)
//    case InternalServerError
//    case RAW(Int, String)
    
    static let NotFound: SimpleResponse = SimpleResponse(statusCode: 404, headers: [ : ], body: "<html><body><h1>404</h1></body></html>")

    public var statusCode: Int

    public var headers: [String: String]

    public var body: String
}
