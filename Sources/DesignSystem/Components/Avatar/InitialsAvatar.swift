import SwiftUI

/// Avatar displaying user initials with a colored background
struct InitialsAvatar: View {
    let initials: String
    let size: AvatarSize
    let backgroundColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)

            Text(initials)
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

// MARK: - Preview

#Preview("Initials Avatar") {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            InitialsAvatar(initials: "JD", size: .xs, backgroundColor: .blue)
            InitialsAvatar(initials: "AB", size: .sm, backgroundColor: .green)
            InitialsAvatar(initials: "CD", size: .md, backgroundColor: .orange)
            InitialsAvatar(initials: "EF", size: .lg, backgroundColor: .purple)
            InitialsAvatar(initials: "GH", size: .xl, backgroundColor: .pink)
        }

        HStack(spacing: 12) {
            InitialsAvatar(initials: "A", size: .lg, backgroundColor: .red)
            InitialsAvatar(initials: "XY", size: .lg, backgroundColor: .teal)
            InitialsAvatar(initials: "ZZ", size: .lg, backgroundColor: .indigo)
        }
    }
    .padding()
}
