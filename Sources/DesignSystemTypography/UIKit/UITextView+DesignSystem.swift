#if canImport(UIKit)
import UIKit

// MARK: - UITextView Design System Extension

extension UITextView {
    /// Apply typography token to text view
    public func apply(typography token: TypographyToken) {
        font = UIFont.ds.font(from: token)
        adjustsFontForContentSizeCategory = true

        // Apply paragraph style with line height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = token.lineHeight
        paragraphStyle.maximumLineHeight = token.lineHeight
        paragraphStyle.lineSpacing = token.lineSpacing

        typingAttributes = [
            .font: UIFont.ds.font(from: token),
            .kern: token.letterSpacing,
            .paragraphStyle: paragraphStyle
        ]

        // Update existing text
        if let text = text, !text.isEmpty {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(typingAttributes, range: NSRange(location: 0, length: text.count))
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

    /// Configure text view with full typography settings
    public func configure(
        scale: FontScale,
        weight: DSFontWeight? = nil,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment = .natural
    ) {
        apply(scale: scale, weight: weight)

        if let textColor = textColor {
            self.textColor = textColor
        }

        self.textAlignment = alignment
    }
}

// MARK: - Design System TextView

/// Pre-configured text view with design system typography
open class DSTextView: UITextView {
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
#endif
