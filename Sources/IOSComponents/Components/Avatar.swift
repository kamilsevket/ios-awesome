import SwiftUI

/// An avatar component for displaying user images or initials
public struct Avatar: View {
    private let source: AvatarSource
    private let size: AvatarSize
    private let shape: AvatarShape
    private let accessibilityText: String

    /// Avatar content source
    public enum AvatarSource {
        case image(Image)
        case url(URL)
        case initials(String)
        case systemIcon(String)
    }

    /// Avatar size presets
    public enum AvatarSize: CGFloat {
        case small = 32
        case medium = 48
        case large = 64
        case extraLarge = 96

        var fontSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 18
            case .large: return 24
            case .extraLarge: return 36
            }
        }
    }

    /// Avatar shape options
    public enum AvatarShape {
        case circle
        case rounded
        case square

        var cornerRadius: CGFloat {
            switch self {
            case .circle: return .infinity
            case .rounded: return 8
            case .square: return 0
            }
        }
    }

    public init(
        source: AvatarSource,
        size: AvatarSize = .medium,
        shape: AvatarShape = .circle,
        accessibilityText: String = "Avatar"
    ) {
        self.source = source
        self.size = size
        self.shape = shape
        self.accessibilityText = accessibilityText
    }

    public var body: some View {
        avatarContent
            .frame(width: size.rawValue, height: size.rawValue)
            #if os(iOS)
            .background(Color(.systemGray5))
            #else
            .background(Color.gray.opacity(0.2))
            #endif
            .clipShape(avatarShape)
            .accessibilityLabel(accessibilityText)
            .accessibilityAddTraits(.isImage)
    }

    @ViewBuilder
    private var avatarContent: some View {
        switch source {
        case .image(let image):
            image
                .resizable()
                .scaledToFill()
        case .url(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholderView
                case .empty:
                    ProgressView()
                @unknown default:
                    placeholderView
                }
            }
        case .initials(let initials):
            Text(initials.prefix(2).uppercased())
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
        case .systemIcon(let iconName):
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .padding(size.rawValue * 0.25)
                .foregroundColor(.gray)
        }
    }

    private var placeholderView: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(size.rawValue * 0.25)
            .foregroundColor(.gray)
    }

    private var avatarShape: AnyShape {
        switch shape {
        case .circle:
            return AnyShape(Circle())
        case .rounded:
            return AnyShape(RoundedRectangle(cornerRadius: shape.cornerRadius))
        case .square:
            return AnyShape(Rectangle())
        }
    }
}

/// Type-erased shape wrapper
public struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    public init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }

    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

#if DEBUG
struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Avatar(source: .initials("JD"), size: .small)
                Avatar(source: .initials("JD"), size: .medium)
                Avatar(source: .initials("JD"), size: .large)
                Avatar(source: .initials("JD"), size: .extraLarge)
            }

            HStack(spacing: 16) {
                Avatar(source: .systemIcon("person.fill"), shape: .circle)
                Avatar(source: .systemIcon("person.fill"), shape: .rounded)
                Avatar(source: .systemIcon("person.fill"), shape: .square)
            }
        }
        .padding()
    }
}
#endif
