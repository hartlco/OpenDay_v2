import XCTest
@testable import LocationService

final class LocationServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LocationService().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
