import XCTest
@testable import FoundationIcons

final class FoundationIconsTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(FoundationIcons.version, "1.0.0")
    }
}
