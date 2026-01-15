import Foundation

// MARK: - DSDateFormatters

/// A collection of pre-configured date formatters for the design system
///
/// DSDateFormatters provides commonly used date formatting patterns with
/// localization support. All formatters are cached for performance.
///
/// Example usage:
/// ```swift
/// let dateString = DSDateFormatters.shortDate.string(from: date)
/// let timeString = DSDateFormatters.time.string(from: date)
/// let customString = DSDateFormatters.custom(format: "EEEE, MMM d").string(from: date)
/// ```
public enum DSDateFormatters {
    // MARK: - Cached Formatters

    private static var cachedFormatters: [String: DateFormatter] = [:]
    private static let lock = NSLock()

    // MARK: - Date Formatters

    /// Short date format (e.g., "1/1/24")
    public static var shortDate: DateFormatter {
        getOrCreate(key: "shortDate") { formatter in
            formatter.dateStyle = .short
            formatter.timeStyle = .none
        }
    }

    /// Medium date format (e.g., "Jan 1, 2024")
    public static var mediumDate: DateFormatter {
        getOrCreate(key: "mediumDate") { formatter in
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        }
    }

    /// Long date format (e.g., "January 1, 2024")
    public static var longDate: DateFormatter {
        getOrCreate(key: "longDate") { formatter in
            formatter.dateStyle = .long
            formatter.timeStyle = .none
        }
    }

    /// Full date format (e.g., "Monday, January 1, 2024")
    public static var fullDate: DateFormatter {
        getOrCreate(key: "fullDate") { formatter in
            formatter.dateStyle = .full
            formatter.timeStyle = .none
        }
    }

    // MARK: - Time Formatters

    /// Short time format (e.g., "1:30 PM")
    public static var shortTime: DateFormatter {
        getOrCreate(key: "shortTime") { formatter in
            formatter.dateStyle = .none
            formatter.timeStyle = .short
        }
    }

    /// Medium time format (e.g., "1:30:45 PM")
    public static var mediumTime: DateFormatter {
        getOrCreate(key: "mediumTime") { formatter in
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
        }
    }

    // MARK: - Date + Time Formatters

    /// Short date and time format
    public static var shortDateTime: DateFormatter {
        getOrCreate(key: "shortDateTime") { formatter in
            formatter.dateStyle = .short
            formatter.timeStyle = .short
        }
    }

    /// Medium date and time format
    public static var mediumDateTime: DateFormatter {
        getOrCreate(key: "mediumDateTime") { formatter in
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
        }
    }

    /// Long date and time format
    public static var longDateTime: DateFormatter {
        getOrCreate(key: "longDateTime") { formatter in
            formatter.dateStyle = .long
            formatter.timeStyle = .short
        }
    }

    // MARK: - ISO Formatters

    /// ISO 8601 date format
    public static var iso8601: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }

    /// ISO 8601 date only format
    public static var iso8601DateOnly: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }

    // MARK: - Relative Formatters

    /// Relative date formatter (e.g., "yesterday", "2 days ago")
    public static var relative: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }

    /// Abbreviated relative date formatter (e.g., "2d ago")
    public static var relativeAbbreviated: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }

    // MARK: - Custom Format

    /// Creates a date formatter with a custom format string
    /// - Parameters:
    ///   - format: The date format string (e.g., "yyyy-MM-dd")
    ///   - locale: Optional locale, defaults to current
    /// - Returns: A configured DateFormatter
    public static func custom(format: String, locale: Locale = .current) -> DateFormatter {
        let key = "custom_\(format)_\(locale.identifier)"
        return getOrCreate(key: key) { formatter in
            formatter.dateFormat = format
            formatter.locale = locale
        }
    }

    /// Creates a localized formatter with template
    /// - Parameters:
    ///   - template: The date format template (e.g., "MMMMd" for "January 1")
    ///   - locale: Optional locale, defaults to current
    /// - Returns: A configured DateFormatter
    public static func localized(template: String, locale: Locale = .current) -> DateFormatter {
        let key = "localized_\(template)_\(locale.identifier)"
        return getOrCreate(key: key) { formatter in
            formatter.setLocalizedDateFormatFromTemplate(template)
            formatter.locale = locale
        }
    }

    // MARK: - Helper Methods

    private static func getOrCreate(key: String, configure: (DateFormatter) -> Void) -> DateFormatter {
        lock.lock()
        defer { lock.unlock() }

        if let cached = cachedFormatters[key] {
            return cached
        }

        let formatter = DateFormatter()
        configure(formatter)
        cachedFormatters[key] = formatter
        return formatter
    }

    /// Clears the formatter cache
    public static func clearCache() {
        lock.lock()
        defer { lock.unlock() }
        cachedFormatters.removeAll()
    }
}

// MARK: - Date Extension

public extension Date {
    /// Formats the date using a DSDateFormatter
    /// - Parameter formatter: The date formatter to use
    /// - Returns: Formatted date string
    func formatted(with formatter: DateFormatter) -> String {
        formatter.string(from: self)
    }

    /// Formats the date using a custom format string
    /// - Parameter format: The date format string
    /// - Returns: Formatted date string
    func formatted(format: String) -> String {
        DSDateFormatters.custom(format: format).string(from: self)
    }

    /// Returns a relative description of the date
    /// - Parameter abbreviated: Whether to use abbreviated form
    /// - Returns: Relative date string
    func relativeFormatted(abbreviated: Bool = false) -> String {
        let formatter = abbreviated ? DSDateFormatters.relativeAbbreviated : DSDateFormatters.relative
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// MARK: - Common Date Format Templates

/// Common date format templates for use with DSDateFormatters
public enum DSDateTemplate {
    /// Month and day (e.g., "January 1")
    public static let monthDay = "MMMMd"
    /// Month, day, and year (e.g., "January 1, 2024")
    public static let monthDayYear = "MMMMdyyyy"
    /// Abbreviated month and day (e.g., "Jan 1")
    public static let abbreviatedMonthDay = "MMMd"
    /// Day of week (e.g., "Monday")
    public static let dayOfWeek = "EEEE"
    /// Abbreviated day of week (e.g., "Mon")
    public static let abbreviatedDayOfWeek = "EEE"
    /// Day of week and time (e.g., "Monday, 1:30 PM")
    public static let dayOfWeekTime = "EEEEjm"
    /// Hour and minute (e.g., "1:30 PM")
    public static let hourMinute = "jm"
    /// Hour only (e.g., "1 PM")
    public static let hourOnly = "j"
    /// Year and month (e.g., "January 2024")
    public static let yearMonth = "yyyyMMMM"
    /// Year only (e.g., "2024")
    public static let yearOnly = "yyyy"
}

// MARK: - Date Range Validation

public extension Date {
    /// Checks if the date is within a given range
    /// - Parameters:
    ///   - start: Start date (inclusive)
    ///   - end: End date (inclusive)
    /// - Returns: True if date is within range
    func isWithin(start: Date, end: Date) -> Bool {
        self >= start && self <= end
    }

    /// Checks if the date is before a given date
    /// - Parameter date: The date to compare against
    /// - Returns: True if self is before the given date
    func isBefore(_ date: Date) -> Bool {
        self < date
    }

    /// Checks if the date is after a given date
    /// - Parameter date: The date to compare against
    /// - Returns: True if self is after the given date
    func isAfter(_ date: Date) -> Bool {
        self > date
    }

    /// Checks if the date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Checks if the date is yesterday
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Checks if the date is tomorrow
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    /// Checks if the date is in the past
    var isPast: Bool {
        self < Date()
    }

    /// Checks if the date is in the future
    var isFuture: Bool {
        self > Date()
    }
}
