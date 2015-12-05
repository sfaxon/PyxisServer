//
//  HTTPRequest.swift
//  PyxisRouter
//
//  Created by Seth Faxon on 8/23/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

public enum HttpMethod: String {
    case Get = "GET"
    case Put = "PUT"
    case Post = "POST"
    case Delete = "DELETE"
    case Unknown
}

public struct HttpRequest {
    public let method: HttpMethod
    public let url: String
    public var headers: [String: String]
    public var body: String?

//    public var urlParams: [(String, String)] // http://stackoverflow.com/questions/1746507/authoritative-position-of-duplicate-http-get-query-keys
//    public var capturedUrlGroups: [String]
//    public var address: String?
    
    //        host - the requested host as a binary, example: "www.example.com"
    //        method - the request method as a binary, example: "GET"
    //        path_info - the path split into segments, example: ["hello", "world"]
    //        script_name - the initial portion of the URL’s path that corresponds to the application routing, as segments, example: ["sub","app"]. It can be used to recover the full_path/1
    //        request_path - the requested path, example: /trailing/and//double//slashes/
    //        port - the requested port as an integer, example: 80
    //        peer - the actual TCP peer that connected, example: {{127, 0, 0, 1}, 12345}. Often this is not the actual IP and port of the client, but rather of a load-balancer or request-router.
    //        remote_ip - the IP of the client, example: {151, 236, 219, 228}. This field is meant to be overwritten by plugs that understand e.g. the X-Forwarded-For header or HAProxy’s PROXY protocol. It defaults to peer’s IP.
    //        req_headers - the request headers as a list, example: [{"content-type", "text/plain"}]
    //        scheme - the request scheme as an atom, example: :http
    //        query_string - the request query string as a binary, example: "foo=bar"
    
    init(method: HttpMethod, url: String, headers: [String: String], body: String?) {
        self.method = method
        self.url = url
        self.headers = headers
        self.body = body
    }
}
