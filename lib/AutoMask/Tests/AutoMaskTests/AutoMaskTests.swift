import XCTest
@testable import AutoMask

final class AutoMaskTests: XCTestCase {

    func test_apply() throws {
        XCTAssertEqual(AutoMask.apply(into: "123456789", with: "##.###.###-#"),"12.345.678-9")
    }

    func test_clear_mask() throws {
        XCTAssertEqual(AutoMask.apply(into: "123456789", with: "AAAA"), "AAAA")
    }

    func test_less_chars() throws {
        XCTAssertEqual(AutoMask.apply(into: "123", with: "#.#.#.#"), "123")
    }

    func test_escape_chars() throws {
        XCTAssertEqual(AutoMask.apply(into: "123", with: "##\\##"), "12#3")
    }
}
