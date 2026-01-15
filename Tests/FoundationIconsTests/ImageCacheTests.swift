import XCTest
@testable import FoundationIcons

final class ImageCacheTests: XCTestCase {

    var cache: ImageCache!

    override func setUp() {
        super.setUp()
        cache = ImageCache(configuration: .default)
    }

    override func tearDown() {
        cache.removeAll()
        cache = nil
        super.tearDown()
    }

    // MARK: - Configuration Tests

    func testDefaultConfiguration() {
        let config = ImageCache.Configuration.default
        XCTAssertEqual(config.countLimit, 100)
        XCTAssertEqual(config.totalCostLimit, 50 * 1024 * 1024) // 50 MB
    }

    func testLowMemoryConfiguration() {
        let config = ImageCache.Configuration.lowMemory
        XCTAssertEqual(config.countLimit, 25)
        XCTAssertEqual(config.totalCostLimit, 10 * 1024 * 1024) // 10 MB
    }

    func testHighCapacityConfiguration() {
        let config = ImageCache.Configuration.highCapacity
        XCTAssertEqual(config.countLimit, 500)
        XCTAssertEqual(config.totalCostLimit, 200 * 1024 * 1024) // 200 MB
    }

    func testCustomConfiguration() {
        let config = ImageCache.Configuration(countLimit: 50, totalCostLimit: 25 * 1024 * 1024)
        XCTAssertEqual(config.countLimit, 50)
        XCTAssertEqual(config.totalCostLimit, 25 * 1024 * 1024)
    }

    // MARK: - Basic Operations Tests

    func testSetAndGetData() {
        let testData = "test image data".data(using: .utf8)!
        let key = "test-key"

        cache.setData(testData, forKey: key)
        let retrievedData = cache.data(forKey: key)

        XCTAssertEqual(retrievedData, testData)
    }

    func testGetNonExistentKey() {
        let data = cache.data(forKey: "non-existent")
        XCTAssertNil(data)
    }

    func testRemoveData() {
        let testData = "test".data(using: .utf8)!
        let key = "test-key"

        cache.setData(testData, forKey: key)
        XCTAssertNotNil(cache.data(forKey: key))

        cache.removeData(forKey: key)
        XCTAssertNil(cache.data(forKey: key))
    }

    func testRemoveAll() {
        let testData = "test".data(using: .utf8)!
        cache.setData(testData, forKey: "key1")
        cache.setData(testData, forKey: "key2")
        cache.setData(testData, forKey: "key3")

        cache.removeAll()

        XCTAssertNil(cache.data(forKey: "key1"))
        XCTAssertNil(cache.data(forKey: "key2"))
        XCTAssertNil(cache.data(forKey: "key3"))
    }

    func testContainsKey() {
        let testData = "test".data(using: .utf8)!
        let key = "test-key"

        XCTAssertFalse(cache.contains(key: key))

        cache.setData(testData, forKey: key)
        XCTAssertTrue(cache.contains(key: key))

        cache.removeData(forKey: key)
        XCTAssertFalse(cache.contains(key: key))
    }

    // MARK: - URL Convenience Tests

    func testSetAndGetDataForURL() {
        let testData = "test".data(using: .utf8)!
        let url = URL(string: "https://example.com/image.png")!

        cache.setData(testData, for: url)
        let retrievedData = cache.data(for: url)

        XCTAssertEqual(retrievedData, testData)
    }

    func testRemoveDataForURL() {
        let testData = "test".data(using: .utf8)!
        let url = URL(string: "https://example.com/image.png")!

        cache.setData(testData, for: url)
        cache.removeData(for: url)

        XCTAssertNil(cache.data(for: url))
    }

    func testContainsURL() {
        let testData = "test".data(using: .utf8)!
        let url = URL(string: "https://example.com/image.png")!

        XCTAssertFalse(cache.contains(url: url))

        cache.setData(testData, for: url)
        XCTAssertTrue(cache.contains(url: url))
    }

    // MARK: - Configuration Update Tests

    func testUpdateConfiguration() {
        let newConfig = ImageCache.Configuration(countLimit: 10, totalCostLimit: 5 * 1024 * 1024)
        cache.updateConfiguration(newConfig)

        XCTAssertEqual(cache.configuration.countLimit, 10)
        XCTAssertEqual(cache.configuration.totalCostLimit, 5 * 1024 * 1024)
    }

    // MARK: - Thread Safety Tests

    func testConcurrentAccess() {
        let expectation = expectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 100

        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)

        for i in 0..<100 {
            queue.async {
                let data = "data-\(i)".data(using: .utf8)!
                self.cache.setData(data, forKey: "key-\(i)")
                _ = self.cache.data(forKey: "key-\(i)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10)
    }

    // MARK: - Shared Instance Tests

    func testSharedInstanceExists() {
        XCTAssertNotNil(ImageCache.shared)
    }

    func testSharedInstanceIsSingleton() {
        let instance1 = ImageCache.shared
        let instance2 = ImageCache.shared
        XCTAssertTrue(instance1 === instance2)
    }
}
