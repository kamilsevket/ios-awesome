import XCTest
@testable import FoundationColor

final class FoundationColorTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(FoundationColor.version, "1.0.0")
    }
}
