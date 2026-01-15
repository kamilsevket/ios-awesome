import SwiftUI

/// Default/placeholder avatar with a person icon
struct IconAvatar: View {
    let size: AvatarSize
    let backgroundColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)

            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size.iconSize, height: size.iconSize)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// MARK: - Preview

#Preview("Icon Avatar") {
    HStack(spacing: 16) {
        IconAvatar(size: .xs, backgroundColor: .gray)
        IconAvatar(size: .sm, backgroundColor: .gray)
        IconAvatar(size: .md, backgroundColor: .gray)
        IconAvatar(size: .lg, backgroundColor: .gray)
        IconAvatar(size: .xl, backgroundColor: .gray)
    }
    .padding()
}
