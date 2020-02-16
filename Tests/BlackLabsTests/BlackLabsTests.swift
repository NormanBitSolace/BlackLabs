import XCTest
@testable import BlackLabs

final class BlackLabsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BlackLabs().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
