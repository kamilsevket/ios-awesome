import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Design System font weights with platform-agnostic naming
public enum DSFontWeight: String, CaseIterable, Sendable {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black

    /// SwiftUI Font.Weight equivalent
    public var swiftUIWeight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }

    #if canImport(UIKit)
    /// UIKit UIFont.Weight equivalent
    public var uiKitWeight: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
    #endif

    /// Numeric weight value (100-900 scale)
    public var numericValue: Int {
        switch self {
        case .ultraLight: return 100
        case .thin: return 200
        case .light: return 300
        case .regular: return 400
        case .medium: return 500
        case .semibold: return 600
        case .bold: return 700
        case .heavy: return 800
        case .black: return 900
        }
    }

    /// Initialize from numeric weight value
    public init(numericValue: Int) {
        switch numericValue {
        case ..<150: self = .ultraLight
        case 150..<250: self = .thin
        case 250..<350: self = .light
        case 350..<450: self = .regular
        case 450..<550: self = .medium
        case 550..<650: self = .semibold
        case 650..<750: self = .bold
        case 750..<850: self = .heavy
        default: self = .black
        }
    }
}
