#if canImport(UIKit)
import UIKit

// MARK: - UILabel Design System Extension

extension UILabel {
    /// Apply typography token to label
    public func apply(typography token: TypographyToken) {
        font = UIFont.ds.font(from: token)
        adjustsFontForContentSizeCategory = true

        // Apply letter spacing
        if token.letterSpacing != 0, let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(
                .kern,
                value: token.letterSpacing,
                range: NSRange(location: 0, length: text.count)
            )
            attributedText = attributedString
        }
    }

    /// Apply font scale with optional weight
    public func apply(
        scale: FontScale,
        weight: DSFontWeight? = nil
    ) {
        let token = TypographyToken(scale: scale, weight: weight)
        apply(typography: token)
    }

    /// Configure label with full typography settings
    public func configure(
        scale: FontScale,
        weight: DSFontWeight? = nil,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int = 0
    ) {
        apply(scale: scale, weight: weight)

        if let textColor = textColor {
            self.textColor = textColor
        }

        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
    }

    /// Apply line height to label
    public func apply(lineHeight: CGFloat) {
        guard let text = text, let font = font else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let baselineOffset = (lineHeight - font.lineHeight) / 4

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset
        ], range: NSRange(location: 0, length: text.count))

        attributedText = attributedString
    }

    /// Apply typography token with line height
    public func applyWithLineHeight(typography token: TypographyToken) {
        apply(typography: token)
        apply(lineHeight: token.lineHeight)
    }
}

// MARK: - Design System Label

/// Pre-configured label with design system typography
open class DSLabel: UILabel {
    /// Current typography token
    public private(set) var typographyToken: TypographyToken?

    /// Initialize with typography token
    public convenience init(typography token: TypographyToken) {
        self.init(frame: .zero)
        setTypography(token)
    }

    /// Initialize with font scale
    public convenience init(scale: FontScale, weight: DSFontWeight? = nil) {
        self.init(frame: .zero)
        setTypography(TypographyToken(scale: scale, weight: weight))
    }

    /// Set typography token
    public func setTypography(_ token: TypographyToken) {
        typographyToken = token
        apply(typography: token)
    }

    /// Update text while preserving typography
    public func setText(_ text: String?) {
        self.text = text
        if let token = typographyToken {
            apply(typography: token)
        }
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            if let token = typographyToken {
                apply(typography: token)
            }
        }
    }
}

// MARK: - Attributed String Builder

/// Builder for creating attributed strings with design system typography
public struct DSAttributedStringBuilder {
    private var attributedString: NSMutableAttributedString

    public init() {
        attributedString = NSMutableAttributedString()
    }

    public init(string: String) {
        attributedString = NSMutableAttributedString(string: string)
    }

    /// Append text with typography token
    @discardableResult
    public mutating func append(
        _ text: String,
        typography token: TypographyToken,
        color: UIColor? = nil
    ) -> Self {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ds.font(from: token),
            .kern: token.letterSpacing
        ]

        if let color = color {
            attributes[.foregroundColor] = color
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = token.lineHeight
        paragraphStyle.maximumLineHeight = token.lineHeight
        attributes[.paragraphStyle] = paragraphStyle

        attributedString.append(NSAttributedString(string: text, attributes: attributes))
        return self
    }

    /// Append text with font scale
    @discardableResult
    public mutating func append(
        _ text: String,
        scale: FontScale,
        weight: DSFontWeight? = nil,
        color: UIColor? = nil
    ) -> Self {
        let token = TypographyToken(scale: scale, weight: weight)
        return append(text, typography: token, color: color)
    }

    /// Build the attributed string
    public func build() -> NSAttributedString {
        attributedString.copy() as! NSAttributedString
    }
}
#endif
