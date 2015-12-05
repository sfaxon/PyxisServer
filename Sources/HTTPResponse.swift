//
//  HTTPResponse.swift
//  PyxisRouter
//
//  Created by Seth Faxon on 8/23/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

public protocol HttpResponseProtocol {
    var statusCode: Int { get set }
    var headers: [String: String] { get set }
    var body: String { get set }
}

public class HttpResponse: HttpResponseProtocol {
    public var statusCode: Int = 200
    public var headers: [String: String] = [:]
    public var body: String = ""
    
    //        resp_body - the response body, by default is an empty string. It is set to nil after the response is set, except for test connections.
    //        resp_charset - the response charset, defaults to “utf-8”
    //        resp_cookies - the response cookies with their name and options
    //        resp_headers - the response headers as a dict, by default cache-control is set to "max-age=0, private, must-revalidate"
    //        status - the response status
    
    public var description: String {
        //        HTTP/1.1 200 OK
        //        Content-Length: 27
        //
        //        hello world for the request
        let headerString = headers.map { "\($0): \($1)" }.joinWithSeparator("\n")
        return "HTTP/1.1 \(statusCode) OK\n\(headerString)\nContent-Length: xx\n\n\(body)"
    }
}


//public enum HttpResponseBody {
//    case HTML(String)
//    case RAW(String)
//    
//    var data: String {
//        switch self {
//        case .HTML(let body):
//            return "<html><body>\(body)</body></html>"
//        case .RAW(let body):
//            return body
//        }
//    }
//}
//
//public protocol HttpResponse {
//    var statusCode: Int { get }
//    var headers: [String: String] { get }
//    var body: String { get }
//}
//
//public protocol HTTPResponder {
//    func call(request: HttpRequest, response: HttpResponse) -> HttpResponse
//}
//
//public struct BaseResponse: HttpResponse, HTTPResponder {
//    public var statusCode: Int = 200
//    public var headers: [String: String] = [:]
//    public var body: String = ""
//    
//    private var request: HttpRequest
//    public init(request: HttpRequest) {
//        self.request = request
//    }
//    
//    public func call(request: HttpRequest, response: HttpResponse) -> HttpResponse {
//        var newResponse = BaseResponse(request: request)
//        newResponse.statusCode = self.statusCode
//        newResponse.headers = self.headers
//        newResponse.body = self.body
//        
//        return self
//    }
//}
//
//public struct HTTPPipeline: HTTPResponder {
//    public var responders: [HTTPResponder] = []
//    
//    public init(responders: [HTTPResponder]) {
//        self.responders = responders
//    }
//    
//    public func call(request: HttpRequest, response: HttpResponse) -> HttpResponse {
//        var response = BaseResponse(request: request) as HttpResponse
//        for (index, responder) in self.responders.enumerate() {
//            print("index: \(index) response: \(response)")
//            response = responder.call(request, response: response)
//        }
//        print("final: \(response)")
//        return response
//    }
//}
//
//

