import XCTest
@testable import AutoMask

final class AutoMaskTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AutoMask.apply(into: "into", mask: "mask"),
                       "apply(into:intomask:mask->String")
    }
}
