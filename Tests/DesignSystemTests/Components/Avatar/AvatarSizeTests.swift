import XCTest
@testable import DesignSystem

final class AvatarSizeTests: XCTestCase {

    // MARK: - Diameter Tests

    func testDiameterValues() {
        XCTAssertEqual(AvatarSize.xs.diameter, 24)
        XCTAssertEqual(AvatarSize.sm.diameter, 32)
        XCTAssertEqual(AvatarSize.md.diameter, 40)
        XCTAssertEqual(AvatarSize.lg.diameter, 56)
        XCTAssertEqual(AvatarSize.xl.diameter, 80)
    }

    func testDiameterIncreasesWithSize() {
        let sizes: [AvatarSize] = [.xs, .sm, .md, .lg, .xl]

        for i in 0..<sizes.count - 1 {
            XCTAssertLessThan(
                sizes[i].diameter,
                sizes[i + 1].diameter,
                "\(sizes[i]) diameter should be less than \(sizes[i + 1]) diameter"
            )
        }
    }

    // MARK: - Font Size Tests

    func testFontSizeValues() {
        XCTAssertEqual(AvatarSize.xs.fontSize, 10)
        XCTAssertEqual(AvatarSize.sm.fontSize, 12)
        XCTAssertEqual(AvatarSize.md.fontSize, 16)
        XCTAssertEqual(AvatarSize.lg.fontSize, 22)
        XCTAssertEqual(AvatarSize.xl.fontSize, 32)
    }

    func testFontSizeIncreasesWithSize() {
        let sizes: [AvatarSize] = [.xs, .sm, .md, .lg, .xl]

        for i in 0..<sizes.count - 1 {
            XCTAssertLessThan(
                sizes[i].fontSize,
                sizes[i + 1].fontSize,
                "\(sizes[i]) fontSize should be less than \(sizes[i + 1]) fontSize"
            )
        }
    }

    // MARK: - Status Indicator Size Tests

    func testStatusIndicatorSizeValues() {
        XCTAssertEqual(AvatarSize.xs.statusIndicatorSize, 8)
        XCTAssertEqual(AvatarSize.sm.statusIndicatorSize, 10)
        XCTAssertEqual(AvatarSize.md.statusIndicatorSize, 12)
        XCTAssertEqual(AvatarSize.lg.statusIndicatorSize, 16)
        XCTAssertEqual(AvatarSize.xl.statusIndicatorSize, 20)
    }

    func testStatusIndicatorSizeIncreasesWithSize() {
        let sizes: [AvatarSize] = [.xs, .sm, .md, .lg, .xl]

        for i in 0..<sizes.count - 1 {
            XCTAssertLessThan(
                sizes[i].statusIndicatorSize,
                sizes[i + 1].statusIndicatorSize,
                "\(sizes[i]) statusIndicatorSize should be less than \(sizes[i + 1]) statusIndicatorSize"
            )
        }
    }

    // MARK: - Ring Width Tests

    func testRingWidthValues() {
        XCTAssertEqual(AvatarSize.xs.ringWidth, 1.5)
        XCTAssertEqual(AvatarSize.sm.ringWidth, 2)
        XCTAssertEqual(AvatarSize.md.ringWidth, 2)
        XCTAssertEqual(AvatarSize.lg.ringWidth, 3)
        XCTAssertEqual(AvatarSize.xl.ringWidth, 4)
    }

    // MARK: - Icon Size Tests

    func testIconSizeValues() {
        XCTAssertEqual(AvatarSize.xs.iconSize, 12)
        XCTAssertEqual(AvatarSize.sm.iconSize, 16)
        XCTAssertEqual(AvatarSize.md.iconSize, 20)
        XCTAssertEqual(AvatarSize.lg.iconSize, 28)
        XCTAssertEqual(AvatarSize.xl.iconSize, 40)
    }

    func testIconSizeIncreasesWithSize() {
        let sizes: [AvatarSize] = [.xs, .sm, .md, .lg, .xl]

        for i in 0..<sizes.count - 1 {
            XCTAssertLessThan(
                sizes[i].iconSize,
                sizes[i + 1].iconSize,
                "\(sizes[i]) iconSize should be less than \(sizes[i + 1]) iconSize"
            )
        }
    }

    // MARK: - CaseIterable Tests

    func testAllCases() {
        XCTAssertEqual(AvatarSize.allCases.count, 5)
        XCTAssertTrue(AvatarSize.allCases.contains(.xs))
        XCTAssertTrue(AvatarSize.allCases.contains(.sm))
        XCTAssertTrue(AvatarSize.allCases.contains(.md))
        XCTAssertTrue(AvatarSize.allCases.contains(.lg))
        XCTAssertTrue(AvatarSize.allCases.contains(.xl))
    }
}
