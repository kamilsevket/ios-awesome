import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - ImageCache

/// A thread-safe in-memory image cache with configurable limits.
///
/// ## Usage
/// ```swift
/// let cache = ImageCache.shared
///
/// // Store an image
/// cache.setImage(image, forKey: "https://example.com/image.png")
///
/// // Retrieve an image
/// if let cached = cache.image(forKey: "https://example.com/image.png") {
///     // Use cached image
/// }
///
/// // Clear cache
/// cache.removeAll()
/// ```
public final class ImageCache: @unchecked Sendable {

    // MARK: - Shared Instance

    /// The shared image cache instance
    public static let shared = ImageCache()

    // MARK: - Configuration

    /// Configuration options for the image cache
    public struct Configuration: Sendable {
        /// Maximum number of images to store
        public let countLimit: Int

        /// Maximum total cost (in bytes) of all cached images
        public let totalCostLimit: Int

        /// Default configuration with reasonable limits
        public static let `default` = Configuration(
            countLimit: 100,
            totalCostLimit: 50 * 1024 * 1024 // 50 MB
        )

        /// Configuration for low memory environments
        public static let lowMemory = Configuration(
            countLimit: 25,
            totalCostLimit: 10 * 1024 * 1024 // 10 MB
        )

        /// Configuration for high capacity caching
        public static let highCapacity = Configuration(
            countLimit: 500,
            totalCostLimit: 200 * 1024 * 1024 // 200 MB
        )

        public init(countLimit: Int, totalCostLimit: Int) {
            self.countLimit = countLimit
            self.totalCostLimit = totalCostLimit
        }
    }

    // MARK: - Properties

    private let cache = NSCache<NSString, CacheEntry>()
    private let lock = NSLock()

    /// The current configuration
    public private(set) var configuration: Configuration

    // MARK: - Cache Entry

    private final class CacheEntry {
        let data: Data
        let timestamp: Date

        init(data: Data) {
            self.data = data
            self.timestamp = Date()
        }
    }

    // MARK: - Initialization

    /// Creates an image cache with the specified configuration
    /// - Parameter configuration: The cache configuration (default: .default)
    public init(configuration: Configuration = .default) {
        self.configuration = configuration
        configureCache()
        setupMemoryWarningObserver()
    }

    private func configureCache() {
        cache.countLimit = configuration.countLimit
        cache.totalCostLimit = configuration.totalCostLimit
    }

    private func setupMemoryWarningObserver() {
        #if canImport(UIKit) && !os(watchOS)
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.removeAll()
        }
        #endif
    }

    // MARK: - Public API

    /// Retrieves cached data for the given key
    /// - Parameter key: The cache key (typically a URL string)
    /// - Returns: The cached data, or nil if not found
    public func data(forKey key: String) -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return cache.object(forKey: key as NSString)?.data
    }

    /// Stores data in the cache
    /// - Parameters:
    ///   - data: The data to cache
    ///   - key: The cache key (typically a URL string)
    public func setData(_ data: Data, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        let entry = CacheEntry(data: data)
        cache.setObject(entry, forKey: key as NSString, cost: data.count)
    }

    /// Removes cached data for the given key
    /// - Parameter key: The cache key to remove
    public func removeData(forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        cache.removeObject(forKey: key as NSString)
    }

    /// Removes all cached data
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        cache.removeAllObjects()
    }

    /// Checks if data exists for the given key
    /// - Parameter key: The cache key to check
    /// - Returns: True if data exists in the cache
    public func contains(key: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return cache.object(forKey: key as NSString) != nil
    }

    /// Updates the cache configuration
    /// - Parameter configuration: The new configuration
    public func updateConfiguration(_ configuration: Configuration) {
        lock.lock()
        defer { lock.unlock() }
        self.configuration = configuration
        configureCache()
    }
}

// MARK: - UIKit Image Support

#if canImport(UIKit)
public extension ImageCache {
    /// Retrieves a cached UIImage for the given key
    /// - Parameter key: The cache key
    /// - Returns: The cached UIImage, or nil if not found
    func image(forKey key: String) -> UIImage? {
        guard let data = data(forKey: key) else { return nil }
        return UIImage(data: data)
    }

    /// Stores a UIImage in the cache
    /// - Parameters:
    ///   - image: The image to cache
    ///   - key: The cache key
    ///   - compressionQuality: JPEG compression quality (0.0-1.0) for lossy compression, or nil for PNG
    func setImage(_ image: UIImage, forKey key: String, compressionQuality: CGFloat? = nil) {
        let data: Data?
        if let quality = compressionQuality {
            data = image.jpegData(compressionQuality: quality)
        } else {
            data = image.pngData()
        }
        if let data = data {
            setData(data, forKey: key)
        }
    }
}
#endif

// MARK: - URL Convenience

public extension ImageCache {
    /// Retrieves cached data for the given URL
    /// - Parameter url: The URL to look up
    /// - Returns: The cached data, or nil if not found
    func data(for url: URL) -> Data? {
        data(forKey: url.absoluteString)
    }

    /// Stores data in the cache for the given URL
    /// - Parameters:
    ///   - data: The data to cache
    ///   - url: The URL to use as the key
    func setData(_ data: Data, for url: URL) {
        setData(data, forKey: url.absoluteString)
    }

    /// Removes cached data for the given URL
    /// - Parameter url: The URL to remove
    func removeData(for url: URL) {
        removeData(forKey: url.absoluteString)
    }

    /// Checks if data exists for the given URL
    /// - Parameter url: The URL to check
    /// - Returns: True if data exists in the cache
    func contains(url: URL) -> Bool {
        contains(key: url.absoluteString)
    }

    #if canImport(UIKit)
    /// Retrieves a cached UIImage for the given URL
    /// - Parameter url: The URL to look up
    /// - Returns: The cached UIImage, or nil if not found
    func image(for url: URL) -> UIImage? {
        image(forKey: url.absoluteString)
    }

    /// Stores a UIImage in the cache for the given URL
    /// - Parameters:
    ///   - image: The image to cache
    ///   - url: The URL to use as the key
    ///   - compressionQuality: JPEG compression quality, or nil for PNG
    func setImage(_ image: UIImage, for url: URL, compressionQuality: CGFloat? = nil) {
        setImage(image, forKey: url.absoluteString, compressionQuality: compressionQuality)
    }
    #endif
}
