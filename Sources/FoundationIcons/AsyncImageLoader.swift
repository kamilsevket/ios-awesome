import SwiftUI

// MARK: - ImageLoadingState

/// Represents the state of an async image load operation
public enum ImageLoadingState: Sendable {
    /// The image has not started loading
    case idle
    /// The image is currently loading
    case loading
    /// The image loaded successfully
    case success(Image)
    /// The image failed to load
    case failure(Error)

    /// Returns true if the state is loading
    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    /// Returns the loaded image if available
    public var image: Image? {
        if case .success(let image) = self { return image }
        return nil
    }

    /// Returns the error if the load failed
    public var error: Error? {
        if case .failure(let error) = self { return error }
        return nil
    }
}

// MARK: - ImageLoadingError

/// Errors that can occur during image loading
public enum ImageLoadingError: Error, LocalizedError, Sendable {
    case invalidURL
    case networkError(Error)
    case invalidData
    case decodingFailed

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid image data"
        case .decodingFailed:
            return "Failed to decode image"
        }
    }
}

// MARK: - AsyncImageLoader

/// An observable image loader that handles async image fetching with caching.
///
/// ## Usage
/// ```swift
/// @StateObject private var loader = AsyncImageLoader()
///
/// var body: some View {
///     VStack {
///         if let image = loader.state.image {
///             image.resizable()
///         } else if loader.state.isLoading {
///             ProgressView()
///         } else {
///             Image(systemName: "photo")
///         }
///     }
///     .task {
///         await loader.load(url: imageURL)
///     }
/// }
/// ```
@MainActor
public final class AsyncImageLoader: ObservableObject {

    // MARK: - Published Properties

    /// The current loading state
    @Published public private(set) var state: ImageLoadingState = .idle

    // MARK: - Properties

    private let cache: ImageCache
    private let session: URLSession
    private var currentTask: Task<Void, Never>?

    // MARK: - Initialization

    /// Creates an async image loader
    /// - Parameters:
    ///   - cache: The image cache to use (default: shared cache)
    ///   - session: The URL session for network requests (default: shared session)
    public init(
        cache: ImageCache = .shared,
        session: URLSession = .shared
    ) {
        self.cache = cache
        self.session = session
    }

    // MARK: - Public API

    /// Loads an image from the given URL
    /// - Parameter url: The URL to load the image from
    public func load(url: URL) async {
        // Cancel any existing task
        currentTask?.cancel()

        state = .loading

        // Check cache first
        if let cachedData = cache.data(for: url),
           let image = createImage(from: cachedData) {
            state = .success(image)
            return
        }

        // Fetch from network
        currentTask = Task {
            do {
                let (data, response) = try await session.data(from: url)

                guard !Task.isCancelled else { return }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    state = .failure(ImageLoadingError.invalidData)
                    return
                }

                guard let image = createImage(from: data) else {
                    state = .failure(ImageLoadingError.decodingFailed)
                    return
                }

                // Cache the data
                cache.setData(data, for: url)

                state = .success(image)
            } catch {
                guard !Task.isCancelled else { return }
                state = .failure(ImageLoadingError.networkError(error))
            }
        }

        await currentTask?.value
    }

    /// Loads an image from a URL string
    /// - Parameter urlString: The URL string to load the image from
    public func load(urlString: String) async {
        guard let url = URL(string: urlString) else {
            state = .failure(ImageLoadingError.invalidURL)
            return
        }
        await load(url: url)
    }

    /// Cancels the current loading operation
    public func cancel() {
        currentTask?.cancel()
        currentTask = nil
        state = .idle
    }

    /// Resets the loader state
    public func reset() {
        cancel()
        state = .idle
    }

    // MARK: - Private Helpers

    private func createImage(from data: Data) -> Image? {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #elseif canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        return Image(nsImage: nsImage)
        #else
        return nil
        #endif
    }
}

// MARK: - CachedAsyncImage

/// A SwiftUI view that loads and displays an image from a URL with caching.
///
/// ## Usage
/// ```swift
/// CachedAsyncImage(url: imageURL) { phase in
///     switch phase {
///     case .empty:
///         ProgressView()
///     case .success(let image):
///         image.resizable()
///     case .failure:
///         Image(systemName: "photo")
///     @unknown default:
///         EmptyView()
///     }
/// }
///
/// // With convenience modifiers
/// CachedAsyncImage(url: imageURL)
///     .placeholder {
///         ProgressView()
///     }
///     .failure {
///         Icon.system(.photo)
///     }
/// ```
public struct CachedAsyncImage<Content: View>: View {

    // MARK: - Properties

    private let url: URL?
    private let cache: ImageCache
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    @StateObject private var loader = AsyncImageLoader()

    // MARK: - Initialization

    /// Creates a cached async image with a custom content builder
    /// - Parameters:
    ///   - url: The URL to load the image from
    ///   - cache: The image cache to use (default: shared)
    ///   - transaction: The transaction for animations
    ///   - content: A closure that returns the view based on the loading phase
    public init(
        url: URL?,
        cache: ImageCache = .shared,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.cache = cache
        self.transaction = transaction
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        content(phase)
            .task(id: url) {
                guard let url = url else { return }
                await loader.load(url: url)
            }
    }

    private var phase: AsyncImagePhase {
        switch loader.state {
        case .idle, .loading:
            return .empty
        case .success(let image):
            return .success(image)
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - CachedAsyncImage Convenience Initializers

public extension CachedAsyncImage where Content == _ConditionalContent<_ConditionalContent<ProgressView<EmptyView, EmptyView>, Image>, Image> {
    /// Creates a cached async image with default placeholder and failure views
    /// - Parameters:
    ///   - url: The URL to load the image from
    ///   - cache: The image cache to use (default: shared)
    init(
        url: URL?,
        cache: ImageCache = .shared
    ) {
        self.init(url: url, cache: cache) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure:
                Image(sfSymbol: .photo)
            @unknown default:
                Image(sfSymbol: .photo)
            }
        }
    }
}

// MARK: - CachedAsyncImage String URL

public extension CachedAsyncImage {
    /// Creates a cached async image from a URL string
    /// - Parameters:
    ///   - urlString: The URL string to load the image from
    ///   - cache: The image cache to use
    ///   - transaction: The transaction for animations
    ///   - content: A closure that returns the view based on the loading phase
    init(
        urlString: String,
        cache: ImageCache = .shared,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.init(
            url: URL(string: urlString),
            cache: cache,
            transaction: transaction,
            content: content
        )
    }
}

// MARK: - Prefetching

/// A utility for prefetching images into the cache
public enum ImagePrefetcher {
    /// Prefetches images from the given URLs into the cache
    /// - Parameters:
    ///   - urls: The URLs to prefetch
    ///   - cache: The cache to store images in
    ///   - session: The URL session to use
    public static func prefetch(
        urls: [URL],
        cache: ImageCache = .shared,
        session: URLSession = .shared
    ) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                // Skip if already cached
                guard !cache.contains(url: url) else { continue }

                group.addTask {
                    do {
                        let (data, _) = try await session.data(from: url)
                        cache.setData(data, for: url)
                    } catch {
                        // Silently fail prefetch operations
                    }
                }
            }
        }
    }

    /// Prefetches images from the given URL strings
    /// - Parameters:
    ///   - urlStrings: The URL strings to prefetch
    ///   - cache: The cache to store images in
    ///   - session: The URL session to use
    public static func prefetch(
        urlStrings: [String],
        cache: ImageCache = .shared,
        session: URLSession = .shared
    ) async {
        let urls = urlStrings.compactMap { URL(string: $0) }
        await prefetch(urls: urls, cache: cache, session: session)
    }
}
