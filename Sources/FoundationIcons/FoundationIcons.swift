// FoundationIcons
// A comprehensive icon and image loading system for iOS applications.
//
// This module provides:
// - Type-safe SF Symbols wrapper (SFSymbol enum)
// - Custom icon management (CustomIcon enum)
// - Unified Icon view component with size and weight options
// - UIKit bridge for UIImage, UIImageView, UIButton, UIBarButtonItem
// - Async image loading with caching (AsyncImageLoader, CachedAsyncImage)
// - Thread-safe in-memory image cache (ImageCache)
// - Image prefetching support (ImagePrefetcher)
//
// ## Quick Start
//
// ### SF Symbols
// ```swift
// // SwiftUI
// Image(sfSymbol: .heart)
// Icon.system(.chevronRight)
//
// // UIKit
// UIImage(sfSymbol: .star)
// button.setImage(sfSymbol: .plus, for: .normal)
// ```
//
// ### Custom Icons
// ```swift
// // SwiftUI
// Image(customIcon: .logo)
// Icon.custom(.brandMark)
//
// // UIKit
// UIImage(customIcon: .logo)
// imageView.setImage(customIcon: .appIcon)
// ```
//
// ### Icon View
// ```swift
// // Basic usage
// Icon.system(.heart)
// Icon.custom(.logo)
//
// // With size
// Icon.system(.star, size: .lg)
//
// // With weight (SF Symbols only)
// Icon.system(.chevronRight, weight: .bold)
//
// // In a button
// IconButton(.heart, size: .lg) {
//     // Handle tap
// }
// ```
//
// ### Async Image Loading
// ```swift
// // Using CachedAsyncImage
// CachedAsyncImage(url: imageURL) { phase in
//     switch phase {
//     case .empty:
//         ProgressView()
//     case .success(let image):
//         image.resizable()
//     case .failure:
//         Icon.system(.photo)
//     @unknown default:
//         EmptyView()
//     }
// }
//
// // Using AsyncImageLoader directly
// @StateObject private var loader = AsyncImageLoader()
//
// VStack {
//     if let image = loader.state.image {
//         image.resizable()
//     }
// }
// .task {
//     await loader.load(url: imageURL)
// }
//
// // Prefetching
// await ImagePrefetcher.prefetch(urls: imageURLs)
// ```
//
// ### Image Cache
// ```swift
// let cache = ImageCache.shared
//
// // Store data
// cache.setData(imageData, forKey: "my-image")
//
// // Retrieve data
// if let data = cache.data(forKey: "my-image") {
//     // Use cached data
// }
//
// // Configure cache limits
// cache.updateConfiguration(.lowMemory)
// ```
//
// ## Icon Sizes
// - `.xs` - 12pt (extra small)
// - `.sm` - 16pt (small)
// - `.md` - 20pt (medium, default)
// - `.lg` - 24pt (large)
// - `.xl` - 32pt (extra large)
// - `.xxl` - 48pt (extra extra large)
//
// ## Adding Custom Icons
// 1. Add your icon assets to `Resources/Assets.xcassets/Icons/`
// 2. Create an imageset folder (e.g., `my-icon.imageset`)
// 3. Add the icon file and Contents.json
// 4. Add a case to the `CustomIcon` enum with the path `Icons/my-icon`
//
// ## Dark Mode Support
// SF Symbols automatically adapt to dark mode.
// For custom icons, use template rendering or provide dark mode variants
// in the Asset Catalog.
//
// ## Platform Support
// - iOS 15.0+
// - macOS 12.0+
// - tvOS 15.0+
// - watchOS 8.0+

import SwiftUI

// Re-export public types for convenience
public typealias FoundationIcon = Icon
public typealias FoundationSFSymbol = SFSymbol
public typealias FoundationCustomIcon = CustomIcon
