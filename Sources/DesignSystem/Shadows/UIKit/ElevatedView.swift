import UIKit

// MARK: - Elevated View

/// A UIView subclass that automatically applies elevation with dark mode support.
open class ElevatedView: UIView {
    // MARK: - Properties

    /// The current elevation level applied to this view.
    public var elevationLevel: ElevationLevel = .level0 {
        didSet {
            updateShadow()
        }
    }

    /// The corner radius for the shadow path optimization.
    public var shadowCornerRadius: CGFloat = 0 {
        didSet {
            updateShadowPath()
        }
    }

    /// Whether to automatically update shadow on trait changes.
    public var automaticDarkModeUpdate: Bool = true

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    /// Initializes the view with a specific elevation level.
    ///
    /// - Parameter elevation: The initial elevation level.
    public convenience init(elevation: ElevationLevel) {
        self.init(frame: .zero)
        self.elevationLevel = elevation
        updateShadow()
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = .systemBackground
    }

    // MARK: - Layout

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    // MARK: - Trait Collection

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard automaticDarkModeUpdate else { return }

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateShadow()
        }
    }

    // MARK: - Shadow Management

    private func updateShadow() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        applyElevation(elevationLevel, isDarkMode: isDarkMode)
    }

    private func updateShadowPath() {
        layer.configureShadowPath(cornerRadius: shadowCornerRadius)
    }
}

// MARK: - Card View

/// A pre-configured elevated view styled as a card.
open class CardView: ElevatedView {
    // MARK: - Properties

    /// The card's corner radius.
    public var cardCornerRadius: CGFloat = 12 {
        didSet {
            layer.cornerRadius = cardCornerRadius
            shadowCornerRadius = cardCornerRadius
        }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCard()
    }

    private func setupCard() {
        elevationLevel = .card
        layer.cornerRadius = cardCornerRadius
        shadowCornerRadius = cardCornerRadius
        clipsToBounds = false
        layer.masksToBounds = false
    }
}

// MARK: - Floating Action View

/// A pre-configured elevated view for floating action buttons.
open class FloatingActionView: ElevatedView {
    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupFloatingAction()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFloatingAction()
    }

    private func setupFloatingAction() {
        elevationLevel = .floating
        clipsToBounds = false
        layer.masksToBounds = false
    }

    // MARK: - Layout

    open override func layoutSubviews() {
        super.layoutSubviews()

        // Make circular if square
        if bounds.width == bounds.height {
            layer.cornerRadius = bounds.width / 2
            shadowCornerRadius = bounds.width / 2
        }
    }
}
