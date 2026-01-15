import SwiftUI

/// Avatar that loads an image asynchronously from a URL
struct ImageAvatar<Fallback: View>: View {
    let url: URL
    let size: AvatarSize
    let fallback: () -> Fallback

    init(
        url: URL,
        size: AvatarSize,
        @ViewBuilder fallback: @escaping () -> Fallback
    ) {
        self.url = url
        self.size = size
        self.fallback = fallback
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                placeholder
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                fallback()
            @unknown default:
                fallback()
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.3))

            ProgressView()
                .scaleEffect(size.placeholderScale)
        }
    }
}

// MARK: - AvatarSize Extension

extension AvatarSize {
    var placeholderScale: CGFloat {
        switch self {
        case .xs: return 0.5
        case .sm: return 0.6
        case .md: return 0.7
        case .lg: return 0.8
        case .xl: return 1.0
        }
    }
}

// MARK: - Preview

#Preview("Image Avatar - Loading") {
    ImageAvatar(
        url: URL(string: "https://example.com/slow-image.jpg")!,
        size: .lg
    ) {
        InitialsAvatar(initials: "JD", size: .lg, backgroundColor: .blue)
    }
    .frame(width: 56, height: 56)
    .clipShape(Circle())
    .padding()
}

#Preview("Image Avatar - Fallback") {
    ImageAvatar(
        url: URL(string: "https://invalid-url-that-will-fail.com/image.jpg")!,
        size: .lg
    ) {
        InitialsAvatar(initials: "FB", size: .lg, backgroundColor: .red)
    }
    .frame(width: 56, height: 56)
    .clipShape(Circle())
    .padding()
}
