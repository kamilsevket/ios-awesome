import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public extension View {
    /// Conditionally applies a transformation
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Conditionally applies one of two transformations
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        ifTrue: (Self) -> TrueContent,
        ifFalse: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }

    #if canImport(UIKit)
    /// Applies a corner radius to specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    #endif

    /// Adds a shadow with common defaults
    func softShadow(
        color: Color = .black.opacity(0.1),
        radius: CGFloat = 8,
        x: CGFloat = 0,
        y: CGFloat = 4
    ) -> some View {
        shadow(color: color, radius: radius, x: x, y: y)
    }

    /// Wraps view in a scroll view if content overflows
    func scrollableIfNeeded(axis: Axis.Set = .vertical) -> some View {
        ScrollView(axis, showsIndicators: false) {
            self
        }
    }

    /// Hides the view completely
    @ViewBuilder
    func hidden(_ isHidden: Bool) -> some View {
        if isHidden {
            EmptyView()
        } else {
            self
        }
    }

    /// Applies an overlay border with rounded corners
    func border(_ color: Color, width: CGFloat = 1, cornerRadius: CGFloat = 0) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: width)
        )
    }
}

#if canImport(UIKit)
/// Custom shape for rounded corners on specific sides
public struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
#endif
