import XCTest
@testable import DesignSystemTypography

final class DesignSystemTypographyTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(DesignSystemTypography.version, "1.0.0")
    }
}
