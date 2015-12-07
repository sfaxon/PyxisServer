import XCTest
import PyxisServer

class RouterTests: XCTestCase {

    var allTests : [(String, () -> ())] {
        return [
            ("testBasics", testBasics),
            ("testSingleRoute", testSingleRoute),
            ("testRouteWithQueryParams", testRouteWithQueryParams),
        ]
    }

    func testBasics() {
        let router = Router()
        
        let p1 = 1
        XCTAssertEqual(p1, 1)
    }
    
    func testSingleRoute() {
        let r = Router()
        r.add(.Get, path: "/foo") { (connection) -> Connection in
            var con = connection
            con.response.body = "foobody"
            return con
        }

        let request = HttpRequest(method: .Get, url: "/foo", headers: [String : String](), body: nil)
        let body = self.runRequest(r, request: request).body
        XCTAssert(body == "foobody", "testSingleRoute did not return expected response")
    }
    
    func testRouteWithQueryParams() {
        let r = Router()
        r.add(.Get, path: "/foo") { (connection) -> Connection in
            var conn = connection
            conn.response.body = "hello"
            return conn
        }
        let request = HttpRequest(method: .Get, url: "/foo?page=1", headers: [String : String](), body: nil)
        let body = self.runRequest(r, request: request).body
        XCTAssert(body == "hello", "testRouteWithQueryParams did not return expected response")
    }
    
    func runRequest(r: Router, request: HttpRequest) -> HttpResponseProtocol {
        let connection = Connection(request: request)
        let responseConnection = r.findHandler(connection)
        let response = responseConnection(connection).response
        return response
    }
}
