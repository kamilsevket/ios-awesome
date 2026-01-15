import UIKit

// MARK: - UIEdgeInsets Extensions

extension UIEdgeInsets {

    /// Creates uniform edge insets using a spacing token
    /// - Parameter spacing: The spacing value for all edges
    /// - Returns: UIEdgeInsets with uniform spacing
    public static func uniform(_ spacing: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    /// Creates uniform edge insets using a spacing token enum
    /// - Parameter token: The spacing token to use
    /// - Returns: UIEdgeInsets with uniform spacing
    public static func uniform(_ token: SpacingToken) -> UIEdgeInsets {
        uniform(token.value)
    }

    /// Creates horizontal edge insets
    /// - Parameter spacing: The horizontal spacing value
    /// - Returns: UIEdgeInsets with horizontal spacing
    public static func horizontal(_ spacing: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }

    /// Creates horizontal edge insets using a spacing token
    /// - Parameter token: The spacing token to use
    /// - Returns: UIEdgeInsets with horizontal spacing
    public static func horizontal(_ token: SpacingToken) -> UIEdgeInsets {
        horizontal(token.value)
    }

    /// Creates vertical edge insets
    /// - Parameter spacing: The vertical spacing value
    /// - Returns: UIEdgeInsets with vertical spacing
    public static func vertical(_ spacing: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
    }

    /// Creates vertical edge insets using a spacing token
    /// - Parameter token: The spacing token to use
    /// - Returns: UIEdgeInsets with vertical spacing
    public static func vertical(_ token: SpacingToken) -> UIEdgeInsets {
        vertical(token.value)
    }

    /// Creates edge insets with spacing tokens for each edge
    /// - Parameters:
    ///   - top: Top spacing token
    ///   - left: Left spacing token
    ///   - bottom: Bottom spacing token
    ///   - right: Right spacing token
    /// - Returns: UIEdgeInsets with token-based spacing
    public static func edges(
        top: SpacingToken = .none,
        left: SpacingToken = .none,
        bottom: SpacingToken = .none,
        right: SpacingToken = .none
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: top.value,
            left: left.value,
            bottom: bottom.value,
            right: right.value
        )
    }
}

// MARK: - NSDirectionalEdgeInsets Extensions

extension NSDirectionalEdgeInsets {

    /// Creates uniform directional edge insets
    /// - Parameter spacing: The spacing value for all edges
    /// - Returns: NSDirectionalEdgeInsets with uniform spacing
    public static func uniform(_ spacing: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }

    /// Creates uniform directional edge insets using a token
    /// - Parameter token: The spacing token to use
    /// - Returns: NSDirectionalEdgeInsets with uniform spacing
    public static func uniform(_ token: SpacingToken) -> NSDirectionalEdgeInsets {
        uniform(token.value)
    }

    /// Creates horizontal directional edge insets
    /// - Parameter spacing: The horizontal spacing value
    /// - Returns: NSDirectionalEdgeInsets with horizontal spacing
    public static func horizontal(_ spacing: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
    }

    /// Creates horizontal directional edge insets using a token
    /// - Parameter token: The spacing token to use
    /// - Returns: NSDirectionalEdgeInsets with horizontal spacing
    public static func horizontal(_ token: SpacingToken) -> NSDirectionalEdgeInsets {
        horizontal(token.value)
    }

    /// Creates vertical directional edge insets
    /// - Parameter spacing: The vertical spacing value
    /// - Returns: NSDirectionalEdgeInsets with vertical spacing
    public static func vertical(_ spacing: CGFloat) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
    }

    /// Creates vertical directional edge insets using a token
    /// - Parameter token: The spacing token to use
    /// - Returns: NSDirectionalEdgeInsets with vertical spacing
    public static func vertical(_ token: SpacingToken) -> NSDirectionalEdgeInsets {
        vertical(token.value)
    }

    /// Creates directional edge insets with spacing tokens
    /// - Parameters:
    ///   - top: Top spacing token
    ///   - leading: Leading spacing token
    ///   - bottom: Bottom spacing token
    ///   - trailing: Trailing spacing token
    /// - Returns: NSDirectionalEdgeInsets with token-based spacing
    public static func edges(
        top: SpacingToken = .none,
        leading: SpacingToken = .none,
        bottom: SpacingToken = .none,
        trailing: SpacingToken = .none
    ) -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(
            top: top.value,
            leading: leading.value,
            bottom: bottom.value,
            trailing: trailing.value
        )
    }
}

// MARK: - UIView Spacing Extensions

extension UIView {

    /// Adds layout margins using a spacing token
    /// - Parameter token: The spacing token for all margins
    public func setLayoutMargins(_ token: SpacingToken) {
        directionalLayoutMargins = .uniform(token)
    }

    /// Adds layout margins using individual spacing tokens
    /// - Parameters:
    ///   - top: Top margin token
    ///   - leading: Leading margin token
    ///   - bottom: Bottom margin token
    ///   - trailing: Trailing margin token
    public func setLayoutMargins(
        top: SpacingToken = .none,
        leading: SpacingToken = .none,
        bottom: SpacingToken = .none,
        trailing: SpacingToken = .none
    ) {
        directionalLayoutMargins = .edges(
            top: top,
            leading: leading,
            bottom: bottom,
            trailing: trailing
        )
    }

    /// Sets horizontal layout margins
    /// - Parameter token: The spacing token for horizontal margins
    public func setHorizontalLayoutMargins(_ token: SpacingToken) {
        directionalLayoutMargins.leading = token.value
        directionalLayoutMargins.trailing = token.value
    }

    /// Sets vertical layout margins
    /// - Parameter token: The spacing token for vertical margins
    public func setVerticalLayoutMargins(_ token: SpacingToken) {
        directionalLayoutMargins.top = token.value
        directionalLayoutMargins.bottom = token.value
    }
}

// MARK: - UIStackView Spacing Extensions

extension UIStackView {

    /// Sets the stack view spacing using a spacing token
    /// - Parameter token: The spacing token to use
    public func setSpacing(_ token: SpacingToken) {
        spacing = token.value
    }

    /// Creates a vertical stack view with design system spacing
    /// - Parameter token: The spacing token for item spacing
    /// - Returns: A configured vertical UIStackView
    public static func vertical(spacing token: SpacingToken = .md) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = token.value
        return stack
    }

    /// Creates a horizontal stack view with design system spacing
    /// - Parameter token: The spacing token for item spacing
    /// - Returns: A configured horizontal UIStackView
    public static func horizontal(spacing token: SpacingToken = .md) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = token.value
        return stack
    }

    /// Configures stack view with content insets
    /// - Parameter token: The spacing token for layout margins
    public func setContentInsets(_ token: SpacingToken) {
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = .uniform(token)
    }

    /// Configures stack view with custom content insets
    /// - Parameters:
    ///   - horizontal: Horizontal spacing token
    ///   - vertical: Vertical spacing token
    public func setContentInsets(horizontal: SpacingToken, vertical: SpacingToken) {
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: vertical.value,
            leading: horizontal.value,
            bottom: vertical.value,
            trailing: horizontal.value
        )
    }
}

// MARK: - UICollectionViewFlowLayout Extensions

extension UICollectionViewFlowLayout {

    /// Sets section insets using a spacing token
    /// - Parameter token: The spacing token for section insets
    public func setSectionInsets(_ token: SpacingToken) {
        sectionInset = .uniform(token)
    }

    /// Sets minimum spacing using spacing tokens
    /// - Parameters:
    ///   - lineSpacing: Spacing between lines
    ///   - itemSpacing: Spacing between items
    public func setMinimumSpacing(
        line lineSpacing: SpacingToken = .md,
        item itemSpacing: SpacingToken = .md
    ) {
        minimumLineSpacing = lineSpacing.value
        minimumInteritemSpacing = itemSpacing.value
    }
}

// MARK: - UITableView Extensions

extension UITableView {

    /// Sets content insets using a spacing token
    /// - Parameter token: The spacing token for content insets
    public func setContentInsets(_ token: SpacingToken) {
        contentInset = .uniform(token)
    }

    /// Sets separator insets using a spacing token
    /// - Parameter leading: Leading inset token
    public func setSeparatorLeadingInset(_ leading: SpacingToken) {
        separatorInset = UIEdgeInsets(
            top: 0,
            left: leading.value,
            bottom: 0,
            right: 0
        )
    }
}

// MARK: - Auto Layout Constraint Helpers

extension NSLayoutConstraint {

    /// Creates a constant constraint using a spacing token
    /// - Parameter token: The spacing token for the constant
    /// - Returns: Self for chaining
    @discardableResult
    public func withConstant(_ token: SpacingToken) -> NSLayoutConstraint {
        constant = token.value
        return self
    }
}

// MARK: - UIButton Configuration Extensions

@available(iOS 15.0, *)
extension UIButton.Configuration {

    /// Sets content insets using a spacing token
    /// - Parameter token: The spacing token for content insets
    /// - Returns: Modified configuration
    public func contentInsets(_ token: SpacingToken) -> UIButton.Configuration {
        var config = self
        config.contentInsets = .uniform(token)
        return config
    }

    /// Sets content insets with separate horizontal and vertical tokens
    /// - Parameters:
    ///   - horizontal: Horizontal spacing token
    ///   - vertical: Vertical spacing token
    /// - Returns: Modified configuration
    public func contentInsets(
        horizontal: SpacingToken,
        vertical: SpacingToken
    ) -> UIButton.Configuration {
        var config = self
        config.contentInsets = NSDirectionalEdgeInsets(
            top: vertical.value,
            leading: horizontal.value,
            bottom: vertical.value,
            trailing: horizontal.value
        )
        return config
    }
}

// MARK: - UITextField Extensions

extension UITextField {

    /// Sets left padding using a spacing token
    /// - Parameter token: The spacing token for left padding
    public func setLeftPadding(_ token: SpacingToken) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: token.value, height: 0))
        leftViewMode = .always
    }

    /// Sets right padding using a spacing token
    /// - Parameter token: The spacing token for right padding
    public func setRightPadding(_ token: SpacingToken) {
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: token.value, height: 0))
        rightViewMode = .always
    }

    /// Sets horizontal padding using a spacing token
    /// - Parameter token: The spacing token for both sides
    public func setHorizontalPadding(_ token: SpacingToken) {
        setLeftPadding(token)
        setRightPadding(token)
    }
}
