import XCTest
@testable import DesignSystemTypography

final class FontFamilyTests: XCTestCase {
    // MARK: - Predefined Families Tests

    func testSystemFont() {
        let system = FontFamily.system

        XCTAssertNil(system.name)
        XCTAssertTrue(system.isSystem)
    }

    func testSFProFonts() {
        XCTAssertEqual(FontFamily.sfPro.name, "SF Pro")
        XCTAssertEqual(FontFamily.sfProDisplay.name, "SF Pro Display")
        XCTAssertEqual(FontFamily.sfProText.name, "SF Pro Text")
        XCTAssertEqual(FontFamily.sfProRounded.name, "SF Pro Rounded")
    }

    func testCustomFont() {
        let customFont = FontFamily.custom("MyCustomFont")

        XCTAssertEqual(customFont.name, "MyCustomFont")
        XCTAssertFalse(customFont.isSystem)
    }

    // MARK: - Equality Tests

    func testEquality() {
        let font1 = FontFamily.custom("Inter")
        let font2 = FontFamily.custom("Inter")

        XCTAssertEqual(font1, font2)
    }

    func testInequality() {
        let font1 = FontFamily.custom("Inter")
        let font2 = FontFamily.custom("Roboto")

        XCTAssertNotEqual(font1, font2)
    }

    // MARK: - Registry Tests

    func testRegistrySharedInstance() {
        let registry1 = FontFamilyRegistry.shared
        let registry2 = FontFamilyRegistry.shared

        XCTAssertTrue(registry1 === registry2)
    }

    func testRegisterConfiguration() {
        let config = FontFamilyRegistry.FontFamilyConfiguration(
            familyName: "TestFont",
            weightMapping: [
                .regular: "TestFont-Regular",
                .bold: "TestFont-Bold"
            ]
        )

        FontFamilyRegistry.shared.register(config)

        let retrieved = FontFamilyRegistry.shared.configuration(for: "TestFont")
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.familyName, "TestFont")
    }

    func testFontNameForWeight() {
        let config = FontFamilyRegistry.FontFamilyConfiguration(
            familyName: "RegisteredFont",
            weightMapping: [
                .regular: "RegisteredFont-Regular",
                .bold: "RegisteredFont-Bold"
            ]
        )

        FontFamilyRegistry.shared.register(config)

        let fontFamily = FontFamily.custom("RegisteredFont")
        let regularName = FontFamilyRegistry.shared.fontName(for: fontFamily, weight: .regular)
        let boldName = FontFamilyRegistry.shared.fontName(for: fontFamily, weight: .bold)

        XCTAssertEqual(regularName, "RegisteredFont-Regular")
        XCTAssertEqual(boldName, "RegisteredFont-Bold")
    }

    func testDefaultFontNameConvention() {
        let fontFamily = FontFamily.custom("UnregisteredFont")
        let fontName = FontFamilyRegistry.shared.fontName(for: fontFamily, weight: .medium)

        // Should follow default naming convention
        XCTAssertEqual(fontName, "UnregisteredFont-Medium")
    }

    func testItalicFontName() {
        let config = FontFamilyRegistry.FontFamilyConfiguration(
            familyName: "ItalicTestFont",
            weightMapping: [
                .regular: "ItalicTestFont-Regular"
            ],
            italicSuffix: "-Italic"
        )

        FontFamilyRegistry.shared.register(config)

        let fontFamily = FontFamily.custom("ItalicTestFont")
        let italicName = FontFamilyRegistry.shared.fontName(for: fontFamily, weight: .regular, italic: true)

        XCTAssertEqual(italicName, "ItalicTestFont-Regular-Italic")
    }

    // MARK: - Predefined Configuration Tests

    func testInterConfiguration() {
        let interConfig = FontFamilyRegistry.FontFamilyConfiguration.inter

        XCTAssertEqual(interConfig.familyName, "Inter")
        XCTAssertEqual(interConfig.weightMapping[.regular], "Inter-Regular")
        XCTAssertEqual(interConfig.weightMapping[.bold], "Inter-Bold")
    }
}
