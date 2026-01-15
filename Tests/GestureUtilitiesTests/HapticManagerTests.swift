import XCTest
@testable import GestureUtilities

final class HapticManagerTests: XCTestCase {

    // MARK: - HapticStyle Tests

    func testHapticStyleAllCases() {
        let allCases = HapticStyle.allCases
        XCTAssertEqual(allCases.count, 9)
        XCTAssertTrue(allCases.contains(.light))
        XCTAssertTrue(allCases.contains(.medium))
        XCTAssertTrue(allCases.contains(.heavy))
        XCTAssertTrue(allCases.contains(.soft))
        XCTAssertTrue(allCases.contains(.rigid))
        XCTAssertTrue(allCases.contains(.success))
        XCTAssertTrue(allCases.contains(.warning))
        XCTAssertTrue(allCases.contains(.error))
        XCTAssertTrue(allCases.contains(.selection))
    }

    func testHapticStyleEquality() {
        XCTAssertEqual(HapticStyle.light, HapticStyle.light)
        XCTAssertEqual(HapticStyle.success, HapticStyle.success)
        XCTAssertNotEqual(HapticStyle.light, HapticStyle.heavy)
        XCTAssertNotEqual(HapticStyle.success, HapticStyle.error)
    }

    // MARK: - HapticPreferences Tests

    func testHapticPreferencesDefault() {
        let prefs = HapticPreferences.default
        XCTAssertTrue(prefs.isEnabled)
        XCTAssertEqual(prefs.intensity, 1.0)
        XCTAssertTrue(prefs.useForGestures)
        XCTAssertTrue(prefs.useForButtons)
    }

    func testHapticPreferencesMinimal() {
        let prefs = HapticPreferences.minimal
        XCTAssertTrue(prefs.isEnabled)
        XCTAssertEqual(prefs.intensity, 0.5)
        XCTAssertFalse(prefs.useForGestures)
        XCTAssertTrue(prefs.useForButtons)
    }

    func testHapticPreferencesDisabled() {
        let prefs = HapticPreferences.disabled
        XCTAssertFalse(prefs.isEnabled)
        XCTAssertEqual(prefs.intensity, 0)
        XCTAssertFalse(prefs.useForGestures)
        XCTAssertFalse(prefs.useForButtons)
    }

    func testHapticPreferencesCustomInit() {
        let prefs = HapticPreferences(
            isEnabled: true,
            intensity: 0.75,
            useForGestures: true,
            useForButtons: false
        )
        XCTAssertTrue(prefs.isEnabled)
        XCTAssertEqual(prefs.intensity, 0.75)
        XCTAssertTrue(prefs.useForGestures)
        XCTAssertFalse(prefs.useForButtons)
    }

    // MARK: - HapticManager Tests

    @MainActor
    func testHapticManagerSharedInstance() {
        let manager1 = HapticManager.shared
        let manager2 = HapticManager.shared
        XCTAssertTrue(manager1 === manager2)
    }

    @MainActor
    func testHapticManagerIsEnabledDefault() {
        let manager = HapticManager()
        XCTAssertTrue(manager.isEnabled)
    }

    @MainActor
    func testHapticManagerCanBeDisabled() {
        let manager = HapticManager()
        manager.isEnabled = false
        XCTAssertFalse(manager.isEnabled)
    }

    @MainActor
    func testHapticManagerTriggerWhenDisabled() {
        let manager = HapticManager()
        manager.isEnabled = false
        // Should not crash when disabled
        manager.trigger(.light)
        manager.trigger(.success)
        manager.trigger(.selection)
    }

    @MainActor
    func testHapticManagerTriggerWithIntensity() {
        let manager = HapticManager()
        // Should not crash
        manager.trigger(.light, intensity: 0.5)
        manager.trigger(.medium, intensity: 1.0)
        manager.trigger(.heavy, intensity: 0.0)
    }

    @MainActor
    func testHapticManagerTriggerSequence() {
        let manager = HapticManager()
        let expectation = XCTestExpectation(description: "Sequence completes")

        manager.triggerSequence([.light, .medium, .heavy], interval: 0.05)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor
    func testHapticManagerTriggerForGesture() {
        let manager = HapticManager()
        // Should not crash for any gesture type
        manager.triggerForGesture(.none)
        manager.triggerForGesture(.tap)
        manager.triggerForGesture(.doubleTap)
        manager.triggerForGesture(.longPress)
        manager.triggerForGesture(.swipe(.left))
        manager.triggerForGesture(.drag)
        manager.triggerForGesture(.pinch)
        manager.triggerForGesture(.rotation)
        manager.triggerForGesture(.custom("test"))
    }
}
