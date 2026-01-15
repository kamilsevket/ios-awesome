import XCTest
@testable import FoundationIcons

final class AsyncImageLoaderTests: XCTestCase {

    // MARK: - ImageLoadingState Tests

    func testImageLoadingStateIdle() {
        let state = ImageLoadingState.idle
        XCTAssertFalse(state.isLoading)
        XCTAssertNil(state.image)
        XCTAssertNil(state.error)
    }

    func testImageLoadingStateLoading() {
        let state = ImageLoadingState.loading
        XCTAssertTrue(state.isLoading)
        XCTAssertNil(state.image)
        XCTAssertNil(state.error)
    }

    func testImageLoadingStateFailure() {
        let error = ImageLoadingError.invalidURL
        let state = ImageLoadingState.failure(error)
        XCTAssertFalse(state.isLoading)
        XCTAssertNil(state.image)
        XCTAssertNotNil(state.error)
    }

    // MARK: - ImageLoadingError Tests

    func testInvalidURLErrorDescription() {
        let error = ImageLoadingError.invalidURL
        XCTAssertEqual(error.errorDescription, "Invalid URL")
    }

    func testInvalidDataErrorDescription() {
        let error = ImageLoadingError.invalidData
        XCTAssertEqual(error.errorDescription, "Invalid image data")
    }

    func testDecodingFailedErrorDescription() {
        let error = ImageLoadingError.decodingFailed
        XCTAssertEqual(error.errorDescription, "Failed to decode image")
    }

    func testNetworkErrorDescription() {
        let underlyingError = NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        let error = ImageLoadingError.networkError(underlyingError)
        XCTAssertTrue(error.errorDescription?.contains("Network error") ?? false)
    }

    // MARK: - AsyncImageLoader Initialization Tests

    @MainActor
    func testAsyncImageLoaderInitialization() {
        let loader = AsyncImageLoader()
        XCTAssertNotNil(loader)

        if case .idle = loader.state {
            // Expected
        } else {
            XCTFail("Initial state should be idle")
        }
    }

    @MainActor
    func testAsyncImageLoaderWithCustomCache() {
        let cache = ImageCache(configuration: .lowMemory)
        let loader = AsyncImageLoader(cache: cache)
        XCTAssertNotNil(loader)
    }

    // MARK: - Cancel and Reset Tests

    @MainActor
    func testCancel() {
        let loader = AsyncImageLoader()
        loader.cancel()

        if case .idle = loader.state {
            // Expected
        } else {
            XCTFail("State should be idle after cancel")
        }
    }

    @MainActor
    func testReset() {
        let loader = AsyncImageLoader()
        loader.reset()

        if case .idle = loader.state {
            // Expected
        } else {
            XCTFail("State should be idle after reset")
        }
    }

    // MARK: - Invalid URL Tests

    @MainActor
    func testLoadInvalidURLString() async {
        let loader = AsyncImageLoader()
        await loader.load(urlString: "not a valid url")

        if case .failure(let error) = loader.state {
            XCTAssertTrue(error is ImageLoadingError)
        } else {
            XCTFail("Should fail with invalid URL")
        }
    }
}
