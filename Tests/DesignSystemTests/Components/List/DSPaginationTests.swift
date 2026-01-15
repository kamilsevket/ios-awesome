import XCTest
import SwiftUI
@testable import DesignSystem

final class DSPaginationTests: XCTestCase {

    // MARK: - DSPaginationState Tests

    func testIdleState() {
        let state = DSPaginationState.idle
        XCTAssertFalse(state.isLoading)
        XCTAssertTrue(state.canLoadMore)
    }

    func testLoadingState() {
        let state = DSPaginationState.loading
        XCTAssertTrue(state.isLoading)
        XCTAssertFalse(state.canLoadMore)
    }

    func testLoadedState() {
        let state = DSPaginationState.loaded
        XCTAssertFalse(state.isLoading)
        XCTAssertTrue(state.canLoadMore)
    }

    func testErrorState() {
        let state = DSPaginationState.error("Test error")
        XCTAssertFalse(state.isLoading)
        XCTAssertFalse(state.canLoadMore)
    }

    func testFinishedState() {
        let state = DSPaginationState.finished
        XCTAssertFalse(state.isLoading)
        XCTAssertFalse(state.canLoadMore)
    }

    func testStateEquality() {
        XCTAssertEqual(DSPaginationState.idle, DSPaginationState.idle)
        XCTAssertEqual(DSPaginationState.loading, DSPaginationState.loading)
        XCTAssertEqual(DSPaginationState.loaded, DSPaginationState.loaded)
        XCTAssertEqual(DSPaginationState.finished, DSPaginationState.finished)
        XCTAssertEqual(DSPaginationState.error("Test"), DSPaginationState.error("Test"))
        XCTAssertNotEqual(DSPaginationState.error("Test1"), DSPaginationState.error("Test2"))
        XCTAssertNotEqual(DSPaginationState.idle, DSPaginationState.loading)
    }

    // MARK: - DSPaginationConfig Tests

    func testDefaultConfig() {
        let config = DSPaginationConfig.default
        XCTAssertEqual(config.threshold, 3)
        XCTAssertEqual(config.debounceInterval, 0.5)
        XCTAssertTrue(config.showsLoadingIndicator)
    }

    func testCustomConfig() {
        let config = DSPaginationConfig(
            threshold: 5,
            debounceInterval: 1.0,
            showsLoadingIndicator: false
        )
        XCTAssertEqual(config.threshold, 5)
        XCTAssertEqual(config.debounceInterval, 1.0)
        XCTAssertFalse(config.showsLoadingIndicator)
    }

    // MARK: - DSPaginatedList Initialization Tests

    func testPaginatedListInitialization() {
        var state = DSPaginationState.idle
        let items = [
            TestPaginationItem(id: 1, name: "Item 1"),
            TestPaginationItem(id: 2, name: "Item 2")
        ]

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: {
            // Load more action
        }
        XCTAssertNotNil(list)
    }

    func testPaginatedListWithEmptyData() {
        var state = DSPaginationState.idle
        let items: [TestPaginationItem] = []

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: { }

        XCTAssertNotNil(list)
    }

    // MARK: - DSPaginatedList Modifier Tests

    func testPaginationConfigModifier() {
        var state = DSPaginationState.idle
        let items = [TestPaginationItem(id: 1, name: "Test")]

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: { }
            .paginationConfig(DSPaginationConfig(threshold: 5))

        XCTAssertNotNil(list)
    }

    func testOnRefreshModifier() {
        var state = DSPaginationState.idle
        let items = [TestPaginationItem(id: 1, name: "Test")]

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: { }
            .onRefresh { }

        XCTAssertNotNil(list)
    }

    func testOnRetryModifier() {
        var state = DSPaginationState.idle
        let items = [TestPaginationItem(id: 1, name: "Test")]
        var retryCalled = false

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: { }
            .onRetry {
                retryCalled = true
            }

        XCTAssertNotNil(list)
        XCTAssertFalse(retryCalled, "Retry should not be called during initialization")
    }

    func testBackgroundColorModifier() {
        var state = DSPaginationState.idle
        let items = [TestPaginationItem(id: 1, name: "Test")]

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: { }
            .backgroundColor(.gray)

        XCTAssertNotNil(list)
    }

    func testSeparatorStyleModifier() {
        var state = DSPaginationState.idle
        let items = [TestPaginationItem(id: 1, name: "Test")]

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: { }
            .separatorStyle(.singleLineInset)

        XCTAssertNotNil(list)
    }

    func testCombinedModifiers() {
        var state = DSPaginationState.idle
        let items = [TestPaginationItem(id: 1, name: "Test")]

        let list = DSPaginatedList(
            items,
            state: Binding(get: { state }, set: { state = $0 })
        ) { item in
            Text(item.name)
        } onLoadMore: { }
            .paginationConfig(.default)
            .onRefresh { }
            .onRetry { }
            .backgroundColor(.white)
            .separatorStyle(.none)

        XCTAssertNotNil(list)
    }

    // MARK: - DSInfiniteScrollModifier Tests

    func testInfiniteScrollModifier() {
        var state = DSPaginationState.idle

        let view = ScrollView {
            VStack {
                Text("Content")
            }
        }
        .dsInfiniteScroll(
            state: Binding(get: { state }, set: { state = $0 }),
            threshold: 100
        ) { }

        XCTAssertNotNil(view)
    }

    func testInfiniteScrollModifierWithCustomThreshold() {
        var state = DSPaginationState.idle

        let view = ScrollView {
            VStack {
                Text("Content")
            }
        }
        .dsInfiniteScroll(
            state: Binding(get: { state }, set: { state = $0 }),
            threshold: 200
        ) { }

        XCTAssertNotNil(view)
    }
}

// MARK: - Test Helper

private struct TestPaginationItem: Identifiable {
    let id: Int
    let name: String
}
