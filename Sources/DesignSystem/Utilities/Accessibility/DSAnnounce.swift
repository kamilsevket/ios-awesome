import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - DS Announcer

/// A utility class for making VoiceOver announcements
/// Provides a clean API for posting accessibility notifications
public final class DSAnnouncer {

    /// Shared instance for convenience
    public static let shared = DSAnnouncer()

    /// Queue for managing announcement timing
    private let queue = DispatchQueue(label: "com.designsystem.accessibility.announcer")

    /// Default delay before announcement (allows UI to settle)
    private let defaultDelay: TimeInterval = 0.1

    private init() {}

    // MARK: - Public Methods

    /// Announces a message to VoiceOver users
    /// - Parameters:
    ///   - message: The message to announce
    ///   - delay: Optional delay before announcement (default: 0.1s)
    ///   - priority: The announcement priority
    public func announce(
        _ message: String,
        delay: TimeInterval? = nil,
        priority: AnnouncementPriority = .normal
    ) {
        let actualDelay = delay ?? defaultDelay

        #if os(iOS) || os(tvOS)
        queue.asyncAfter(deadline: .now() + actualDelay) {
            DispatchQueue.main.async {
                let attributedMessage = NSAttributedString(
                    string: message,
                    attributes: [
                        .accessibilitySpeechQueueAnnouncement: priority == .immediate ? false : true
                    ]
                )

                UIAccessibility.post(
                    notification: .announcement,
                    argument: attributedMessage
                )
            }
        }
        #elseif os(macOS)
        queue.asyncAfter(deadline: .now() + actualDelay) {
            DispatchQueue.main.async {
                NSAccessibility.post(
                    element: NSApp.mainWindow as Any,
                    notification: .announcementRequested,
                    userInfo: [
                        .announcement: message,
                        .priority: priority == .immediate
                            ? NSAccessibilityPriorityLevel.high
                            : NSAccessibilityPriorityLevel.medium
                    ]
                )
            }
        }
        #endif
    }

    /// Announces a screen change
    /// - Parameter screenName: The name of the new screen
    public func announceScreenChange(_ screenName: String) {
        #if os(iOS) || os(tvOS)
        queue.asyncAfter(deadline: .now() + defaultDelay) {
            DispatchQueue.main.async {
                UIAccessibility.post(
                    notification: .screenChanged,
                    argument: screenName
                )
            }
        }
        #endif
    }

    /// Announces a layout change and optionally focuses an element
    /// - Parameter focusElement: Optional element to focus after announcement
    public func announceLayoutChange(focusElement: Any? = nil) {
        #if os(iOS) || os(tvOS)
        queue.asyncAfter(deadline: .now() + defaultDelay) {
            DispatchQueue.main.async {
                UIAccessibility.post(
                    notification: .layoutChanged,
                    argument: focusElement
                )
            }
        }
        #endif
    }

    /// Announces that a page has scrolled
    /// - Parameter message: Description of the new visible content
    public func announcePageScroll(_ message: String) {
        #if os(iOS) || os(tvOS)
        queue.asyncAfter(deadline: .now() + defaultDelay) {
            DispatchQueue.main.async {
                UIAccessibility.post(
                    notification: .pageScrolled,
                    argument: message
                )
            }
        }
        #endif
    }

    // MARK: - Convenience Methods

    /// Announces an action completion
    /// - Parameter action: Description of the completed action
    public func announceActionCompleted(_ action: String) {
        announce("\(action) completed")
    }

    /// Announces an error
    /// - Parameter error: The error message
    public func announceError(_ error: String) {
        announce("Error: \(error)", priority: .immediate)
    }

    /// Announces a loading state
    /// - Parameter isLoading: Whether loading has started or finished
    public func announceLoading(_ isLoading: Bool) {
        let message = isLoading ? "Loading" : "Loading complete"
        announce(message)
    }

    /// Announces item count in a list
    /// - Parameters:
    ///   - count: Number of items
    ///   - itemType: Type of items (e.g., "result", "message")
    public func announceItemCount(_ count: Int, itemType: String) {
        let itemWord = count == 1 ? itemType : "\(itemType)s"
        announce("\(count) \(itemWord)")
    }
}

// MARK: - Announcement Priority

public enum AnnouncementPriority {
    /// Normal priority, queued with other announcements
    case normal

    /// High priority, interrupts other announcements
    case immediate
}

// MARK: - View Extension for Announcements

extension View {
    /// Announces a message when a value changes
    /// - Parameters:
    ///   - message: The message to announce
    ///   - value: The value to observe
    /// - Returns: A view that announces changes
    public func dsAnnounce<V: Equatable>(
        _ message: String,
        when value: V
    ) -> some View {
        modifier(DSAnnounceOnChangeModifier(message: message, value: value))
    }

    /// Announces a dynamic message when a value changes
    /// - Parameters:
    ///   - message: Closure that returns the message based on the value
    ///   - value: The value to observe
    /// - Returns: A view that announces changes
    public func dsAnnounce<V: Equatable>(
        _ message: @escaping (V) -> String,
        when value: V
    ) -> some View {
        modifier(DSAnnounceOnChangeModifierDynamic(message: message, value: value))
    }

    /// Announces a message immediately
    /// Use sparingly - typically in response to user actions
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public func dsAnnounce(_ message: String) -> some View {
        accessibilityAnnouncement(message)
    }
}

// MARK: - Announce Modifiers

private struct DSAnnounceOnChangeModifier<V: Equatable>: ViewModifier {
    let message: String
    let value: V

    func body(content: Content) -> some View {
        content.onChange(of: value) { _ in
            DSAnnouncer.shared.announce(message)
        }
    }
}

private struct DSAnnounceOnChangeModifierDynamic<V: Equatable>: ViewModifier {
    let message: (V) -> String
    let value: V

    func body(content: Content) -> some View {
        content.onChange(of: value) { newValue in
            DSAnnouncer.shared.announce(message(newValue))
        }
    }
}

// MARK: - Global Announce Function

/// Convenience function for quick announcements
/// - Parameters:
///   - message: The message to announce
///   - priority: The announcement priority
public func dsAnnounce(
    _ message: String,
    priority: AnnouncementPriority = .normal
) {
    DSAnnouncer.shared.announce(message, priority: priority)
}
