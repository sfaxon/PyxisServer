//
//  HTTPServer.swift
//  PyxisEchoC
//
//  Created by Seth Faxon on 6/28/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//


#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public class HttpServer {
  var   serverSocket : Int32 = 0
  var  serverAddress : sockaddr_in?
  var     bufferSize : Int = 1024
  var router : Router

  func sockaddr_cast(p: UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<sockaddr> {
    return UnsafeMutablePointer<sockaddr>(p)
  }

  func echo(socket: Int32, _ output: String) {
    output.withCString { (bytes) in
       send(socket, bytes, Int(strlen(bytes)), 0)
    }
  }

  public init(port: UInt16, router: Router) {
    self.router = router
    #if os(Linux)
    serverSocket = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
    #else
    serverSocket = socket(AF_INET, Int32(SOCK_STREAM), 0)
    #endif
    if (serverSocket > 0) {
      print("Socket init: OK")
    }

    #if os(Linux)
    serverAddress = sockaddr_in(
      sin_family: sa_family_t(AF_INET),
      sin_port: htons(port),
      sin_addr: in_addr(s_addr: in_addr_t(0)),
      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
    )
    #else
    serverAddress = sockaddr_in(
      sin_len: __uint8_t(sizeof(sockaddr_in)),
      sin_family: sa_family_t(AF_INET),
      sin_port: htons(port),
      sin_addr: in_addr(s_addr: in_addr_t(0)),
      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
    )
    #endif

    setsockopt(serverSocket, SOL_SOCKET, SO_RCVBUF, &bufferSize, socklen_t(sizeof(Int)))

    let serverBind = bind(serverSocket, sockaddr_cast(&serverAddress), socklen_t(UInt8(sizeof(sockaddr_in))))
    if (serverBind >= 0) {
      print("Server started at port \(port)")
    }
  }

  func htons(value: CUnsignedShort) -> CUnsignedShort {
    return (value << 8) + (value >> 8);
  }

  public func start() {
    stop()
    while (true) {
      if (listen(serverSocket, 10) < 0) {
        exit(1)
      }

      let clientSocket = accept(serverSocket, nil, nil)

      let parser = HttpParser()
      do {
          while let request = try parser.nextHttpRequest(clientSocket) {
              print("HTTPServer processing request")
              let keepAlive = parser.supportsKeepAlive(request.headers)
              let connection = Connection(request: request)

              let responseConnection = self.router.findHandler(connection)

              respond(clientSocket, response: responseConnection(connection).response, keepAlive: keepAlive)

              if !keepAlive { break }
          }
          // Socket.release(socket)
          // HttpServer.lock(self.clientSocketsLock) {
          //     self.clientSockets.remove(socket)
          // }
      } catch HTTPParserError.Generic {
        print("caught generic parser error")
      }

      catch {
          print("caught error in parser land")
      }


      // let msg = "Hello World"
      // let contentLength = msg.utf8.count

      // echo(clientSocket, "HTTP/1.1 200 OK\n")
      // echo(clientSocket, "Server: Swift Web Server\n")
      // echo(clientSocket, "Content-length: \(contentLength)\n")
      // echo(clientSocket, "Content-type: text-plain\n")
      // echo(clientSocket, "\r\n")

      // echo(clientSocket, msg)

      // print("Response sent: '\(msg)' - Length: \(contentLength)")

      close(clientSocket)
    }
  }

  public func stop() {
    #if os(Linux)
    shutdown(serverSocket, Int32(SHUT_RDWR))
    #else
    shutdown(serverSocket, SHUT_RDWR)
    #endif
  }

  func respond(clientSocket: CInt, response: HttpResponseProtocol, keepAlive: Bool) {
    let msg = response.body
    print("msg: \(msg)")
    let contentLength = msg.utf8.count

    echo(clientSocket, "HTTP/1.1 200 OK\n")
    echo(clientSocket, "Server: Swift Web Server\n")
    // echo(clientSocket, "Content-length: \(contentLength)\n")
    echo(clientSocket, "Content-type: text-plain\n")
    // for (header, value) in response.headers {
    //   echo(clientSocket, "\(header): \(value)")
    // }
    echo(clientSocket, "\r\n")

    echo(clientSocket, msg)
//     do {
//         try Socket.writeUTF8(socket, string: "HTTP/1.1 \(response.statusCode) \(HTTPResponsePhrase(code: response.statusCode).lookup)\r\n")
//         let body = response.body

//         try Socket.writeASCII(socket, string: "Content-Length: \(body.characters.count)\r\n")
// //            } else {
// //                try Socket.writeASCII(socket, string: "Content-Length: 0\r\n")
// //            }
//         if keepAlive {
//             try Socket.writeASCII(socket, string: "Connection: keep-alive\r\n")
//         }
//         for (name, value) in response.headers {
//             try Socket.writeASCII(socket, string: "\(name): \(value)\r\n")
//         }
//         try Socket.writeASCII(socket, string: "\r\n")
// //            if let body = response.body() {
//             try Socket.writeData(socket, data: body.dataUsingEncoding(NSUTF8StringEncoding)!)
// //            }
//     } catch {
//         print("write error in respond")
//     }
  }
}
