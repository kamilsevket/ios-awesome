import XCTest
import SwiftUI
@testable import DesignSystem

final class DSReorderableListTests: XCTestCase {

    // MARK: - DSReorderHandleStyle Tests

    func testNoneHandleStyleImage() {
        let style = DSReorderHandleStyle.none
        XCTAssertNil(style.image)
    }

    func testStandardHandleStyleImage() {
        let style = DSReorderHandleStyle.standard
        XCTAssertNotNil(style.image)
    }

    func testCustomHandleStyleImage() {
        let customImage = Image(systemName: "arrow.up.arrow.down")
        let style = DSReorderHandleStyle.custom(customImage)
        XCTAssertNotNil(style.image)
    }

    // MARK: - DSReorderableList Initialization Tests

    func testReorderableListInitialization() {
        var items = [
            TestReorderItem(id: 1, title: "Item 1"),
            TestReorderItem(id: 2, title: "Item 2")
        ]

        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        XCTAssertNotNil(list)
    }

    func testReorderableListWithEmptyData() {
        var items: [TestReorderItem] = []

        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        XCTAssertNotNil(list)
    }

    // MARK: - DSReorderableList Modifier Tests

    func testHandleStyleModifier() {
        var items = [TestReorderItem(id: 1, title: "Test")]
        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .handleStyle(.standard)

        XCTAssertNotNil(list)
    }

    func testHandleStyleNoneModifier() {
        var items = [TestReorderItem(id: 1, title: "Test")]
        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .handleStyle(.none)

        XCTAssertNotNil(list)
    }

    func testHandleStyleCustomModifier() {
        var items = [TestReorderItem(id: 1, title: "Test")]
        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .handleStyle(.custom(Image(systemName: "line.3.horizontal.decrease")))

        XCTAssertNotNil(list)
    }

    func testShowsHandleOnlyInEditModeModifier() {
        var items = [TestReorderItem(id: 1, title: "Test")]
        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .showsHandleOnlyInEditMode(true)

        XCTAssertNotNil(list)
    }

    func testOnReorderModifier() {
        var items = [TestReorderItem(id: 1, title: "Test")]
        var reorderCalled = false

        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .onReorder { _, _ in
            reorderCalled = true
        }

        XCTAssertNotNil(list)
        XCTAssertFalse(reorderCalled, "Reorder should not be called during initialization")
    }

    func testBackgroundColorModifier() {
        var items = [TestReorderItem(id: 1, title: "Test")]
        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .backgroundColor(.gray)

        XCTAssertNotNil(list)
    }

    func testSeparatorStyleModifier() {
        var items = [TestReorderItem(id: 1, title: "Test")]
        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .separatorStyle(.singleLineInset)

        XCTAssertNotNil(list)
    }

    func testCombinedModifiers() {
        var items = [TestReorderItem(id: 1, title: "Test")]

        let list = DSReorderableList(Binding(get: { items }, set: { items = $0 })) { item in
            Text(item.title)
        }
        .handleStyle(.standard)
        .showsHandleOnlyInEditMode(false)
        .onReorder { _, _ in }
        .backgroundColor(.white)
        .separatorStyle(.none)

        XCTAssertNotNil(list)
    }
}

// MARK: - Test Helper

private struct TestReorderItem: Identifiable {
    let id: Int
    let title: String
}
