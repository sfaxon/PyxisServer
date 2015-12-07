import XCTest
import PyxisServer

class PackageTests: XCTestCase {

    var allTests : [(String, () -> ())] {
        return [
            ("testBasics", testBasics),
        ]
    }

    func testBasics() {
        let p1 = 1
        XCTAssertEqual(p1, 1)
    }
}
