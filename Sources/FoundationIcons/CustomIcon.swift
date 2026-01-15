import SwiftUI

// MARK: - CustomIcon

/// Enumeration of custom app-specific icons stored in the Asset Catalog.
///
/// ## Usage
/// ```swift
/// // SwiftUI Image
/// Image(customIcon: .logo)
///
/// // Icon view
/// Icon.custom(.appIcon)
///
/// // UIKit
/// UIImage(customIcon: .brandMark)
/// ```
///
/// ## Adding New Icons
/// 1. Add the icon to `Resources/Assets.xcassets/Icons/`
/// 2. Add a new case to this enum matching the asset name
/// 3. The icon will automatically be available throughout the app
public enum CustomIcon: String, CaseIterable, Sendable {

    // MARK: - Brand

    /// Main app logo
    case logo = "Icons/logo"

    /// App icon variant
    case appIcon = "Icons/app-icon"

    /// Brand mark (simplified logo)
    case brandMark = "Icons/brand-mark"

    /// Wordmark (text-based logo)
    case wordmark = "Icons/wordmark"

    // MARK: - Navigation

    /// Custom home icon
    case home = "Icons/home"

    /// Custom menu icon
    case menu = "Icons/menu"

    /// Custom back arrow
    case back = "Icons/back"

    /// Custom forward arrow
    case forward = "Icons/forward"

    // MARK: - Features

    /// Dashboard icon
    case dashboard = "Icons/dashboard"

    /// Analytics icon
    case analytics = "Icons/analytics"

    /// Settings icon
    case settings = "Icons/settings"

    /// Profile icon
    case profile = "Icons/profile"

    /// Notifications icon
    case notifications = "Icons/notifications"

    // MARK: - Actions

    /// Custom add/create icon
    case add = "Icons/add"

    /// Custom edit icon
    case edit = "Icons/edit"

    /// Custom delete icon
    case delete = "Icons/delete"

    /// Custom share icon
    case share = "Icons/share"

    /// Custom favorite icon
    case favorite = "Icons/favorite"

    // MARK: - Status

    /// Success/check icon
    case success = "Icons/success"

    /// Warning icon
    case warning = "Icons/warning"

    /// Error icon
    case error = "Icons/error"

    /// Info icon
    case info = "Icons/info"

    // MARK: - Social

    /// Custom social share icon
    case socialShare = "Icons/social-share"

    /// Custom comment icon
    case comment = "Icons/comment"

    /// Custom like icon
    case like = "Icons/like"

    // MARK: - Misc

    /// Empty state illustration
    case emptyState = "Icons/empty-state"

    /// Loading/spinner icon
    case loading = "Icons/loading"

    /// Placeholder icon
    case placeholder = "Icons/placeholder"

    /// The asset catalog path for this icon
    public var assetName: String {
        rawValue
    }

    /// Returns the SwiftUI Image for this custom icon
    public var image: Image {
        Image(rawValue, bundle: .module)
    }
}

// MARK: - Image Extension

public extension Image {
    /// Creates an Image from a CustomIcon
    /// - Parameter customIcon: The custom icon to display
    init(customIcon: CustomIcon) {
        self.init(customIcon.rawValue, bundle: .module)
    }
}

// MARK: - Label Extension

public extension Label where Title == Text, Icon == Image {
    /// Creates a Label with a custom icon
    /// - Parameters:
    ///   - title: The text to display
    ///   - customIcon: The custom icon to use
    init(_ title: String, customIcon: CustomIcon) {
        self.init {
            Text(title)
        } icon: {
            Image(customIcon: customIcon)
        }
    }

    /// Creates a Label with a custom icon
    /// - Parameters:
    ///   - titleKey: The localization key for the text
    ///   - customIcon: The custom icon to use
    init(_ titleKey: LocalizedStringKey, customIcon: CustomIcon) {
        self.init {
            Text(titleKey)
        } icon: {
            Image(customIcon: customIcon)
        }
    }
}
