//
//  HTTPServer.swift
//  PyxisEchoC
//
//  Created by Seth Faxon on 6/28/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//


enum ServerError: ErrorType {
    case Generic
}

public class HttpServer {
    
    var clientSockets: Set<CInt> = []
    let clientSocketsLock = 0
    var acceptSocket: CInt = -1

    let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
//    func routes() -> [String] { return self.router.routes() }
    
    public func start(listenPort: in_port_t = 8080) throws -> Bool {
        stop()
        do {
            if let socket = try Socket.tcpForListen(listenPort) {
                self.acceptSocket = socket
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    self.listenOnSocket(socket)
                    self.stop()
                })
                return true
            }
        } catch {
            print("errors in the big block")
            throw ServerError.Generic
        }
        return false
    }
    
    private func listenOnSocket(socket: CInt) {
        while let socket = Socket.acceptClientSocket(self.acceptSocket) {
            HttpServer.lock(self.clientSocketsLock) {
                self.clientSockets.insert(socket)
            }
            if self.acceptSocket == -1 { return }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                let parser = HttpParser()
                do {
                    while let request = try parser.nextHttpRequest(socket) {
                        let keepAlive = parser.supportsKeepAlive(request.headers)
                        let connection = Connection(request: request)
                        
                        let responseConnection = self.router.findHandler(connection)
                        
                        HttpServer.respond(socket, response: responseConnection(connection).response, keepAlive: keepAlive)
                        
                        if !keepAlive { break }
                    }
                    Socket.release(socket)
                    HttpServer.lock(self.clientSocketsLock) {
                        self.clientSockets.remove(socket)
                    }
                } catch {
                    print("caught error in parser land")
                }
            })
        }
    }
    
    func stop() {
        Socket.release(acceptSocket)
        acceptSocket = -1
        HttpServer.lock(self.clientSocketsLock) {
            for clientSocket in self.clientSockets {
                Socket.release(clientSocket)
            }
            self.clientSockets.removeAll(keepCapacity: true)
        }
    }
    
    class func asciiRange(value: String) -> NSRange {
        return NSMakeRange(0, value.lengthOfBytesUsingEncoding(NSASCIIStringEncoding))
    }
    
    class func lock(handle: AnyObject, closure: () -> ()) {
        objc_sync_enter(handle)
        closure()
        objc_sync_exit(handle)
    }
    
    class func respond(socket: CInt, response: HttpResponseProtocol, keepAlive: Bool) {
        do {
            try Socket.writeUTF8(socket, string: "HTTP/1.1 \(response.statusCode) \(HTTPResponsePhrase(code: response.statusCode).lookup)\r\n")
            let body = response.body

            try Socket.writeASCII(socket, string: "Content-Length: \(body.characters.count)\r\n")
//            } else {
//                try Socket.writeASCII(socket, string: "Content-Length: 0\r\n")
//            }
            if keepAlive {
                try Socket.writeASCII(socket, string: "Connection: keep-alive\r\n")
            }
            for (name, value) in response.headers {
                try Socket.writeASCII(socket, string: "\(name): \(value)\r\n")
            }
            try Socket.writeASCII(socket, string: "\r\n")
//            if let body = response.body() {
                try Socket.writeData(socket, data: body.dataUsingEncoding(NSUTF8StringEncoding)!)
//            }
        } catch {
            print("write error in respond")
        }
    }
}
