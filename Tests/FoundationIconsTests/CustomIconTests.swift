import XCTest
import SwiftUI
@testable import FoundationIcons

final class CustomIconTests: XCTestCase {

    // MARK: - Raw Value Tests

    func testBrandIconsHaveValidRawValues() {
        XCTAssertEqual(CustomIcon.logo.rawValue, "Icons/logo")
        XCTAssertEqual(CustomIcon.appIcon.rawValue, "Icons/app-icon")
        XCTAssertEqual(CustomIcon.brandMark.rawValue, "Icons/brand-mark")
        XCTAssertEqual(CustomIcon.wordmark.rawValue, "Icons/wordmark")
    }

    func testNavigationIconsHaveValidRawValues() {
        XCTAssertEqual(CustomIcon.home.rawValue, "Icons/home")
        XCTAssertEqual(CustomIcon.menu.rawValue, "Icons/menu")
        XCTAssertEqual(CustomIcon.back.rawValue, "Icons/back")
        XCTAssertEqual(CustomIcon.forward.rawValue, "Icons/forward")
    }

    func testFeatureIconsHaveValidRawValues() {
        XCTAssertEqual(CustomIcon.dashboard.rawValue, "Icons/dashboard")
        XCTAssertEqual(CustomIcon.analytics.rawValue, "Icons/analytics")
        XCTAssertEqual(CustomIcon.settings.rawValue, "Icons/settings")
        XCTAssertEqual(CustomIcon.profile.rawValue, "Icons/profile")
        XCTAssertEqual(CustomIcon.notifications.rawValue, "Icons/notifications")
    }

    func testStatusIconsHaveValidRawValues() {
        XCTAssertEqual(CustomIcon.success.rawValue, "Icons/success")
        XCTAssertEqual(CustomIcon.warning.rawValue, "Icons/warning")
        XCTAssertEqual(CustomIcon.error.rawValue, "Icons/error")
        XCTAssertEqual(CustomIcon.info.rawValue, "Icons/info")
    }

    // MARK: - Asset Name Tests

    func testAssetNameMatchesRawValue() {
        for icon in CustomIcon.allCases {
            XCTAssertEqual(icon.assetName, icon.rawValue)
        }
    }

    // MARK: - All Cases Tests

    func testAllCasesIsNotEmpty() {
        XCTAssertFalse(CustomIcon.allCases.isEmpty)
    }

    func testAllCasesContainsExpectedIcons() {
        XCTAssertTrue(CustomIcon.allCases.contains(.logo))
        XCTAssertTrue(CustomIcon.allCases.contains(.appIcon))
        XCTAssertTrue(CustomIcon.allCases.contains(.placeholder))
    }

    // MARK: - Uniqueness Tests

    func testAllRawValuesAreUnique() {
        let rawValues = CustomIcon.allCases.map { $0.rawValue }
        let uniqueValues = Set(rawValues)
        XCTAssertEqual(rawValues.count, uniqueValues.count, "Duplicate raw values found")
    }

    // MARK: - Path Format Tests

    func testAllIconsHaveIconsPrefix() {
        for icon in CustomIcon.allCases {
            XCTAssertTrue(icon.rawValue.hasPrefix("Icons/"), "Icon \(icon) should have 'Icons/' prefix")
        }
    }

    // MARK: - Category Coverage Tests

    func testBrandCategoryExists() {
        let brandIcons: [CustomIcon] = [.logo, .appIcon, .brandMark, .wordmark]
        for icon in brandIcons {
            XCTAssertTrue(CustomIcon.allCases.contains(icon))
        }
    }

    func testActionCategoryExists() {
        let actionIcons: [CustomIcon] = [.add, .edit, .delete, .share, .favorite]
        for icon in actionIcons {
            XCTAssertTrue(CustomIcon.allCases.contains(icon))
        }
    }

    func testStatusCategoryExists() {
        let statusIcons: [CustomIcon] = [.success, .warning, .error, .info]
        for icon in statusIcons {
            XCTAssertTrue(CustomIcon.allCases.contains(icon))
        }
    }
}
