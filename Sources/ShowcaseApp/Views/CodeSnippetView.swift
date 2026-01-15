import SwiftUI

/// View for displaying code snippets with syntax highlighting and copy functionality
public struct CodeSnippetView: View {
    let code: String
    @State private var isCopied = false

    public init(code: String) {
        self.code = code
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with copy button
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(Color.red.opacity(0.8)).frame(width: 12, height: 12)
                    Circle().fill(Color.yellow.opacity(0.8)).frame(width: 12, height: 12)
                    Circle().fill(Color.green.opacity(0.8)).frame(width: 12, height: 12)
                }

                Spacer()

                Text("Swift")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Button {
                    copyToClipboard()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 12))
                        Text(isCopied ? "Copied!" : "Copy")
                            .font(.caption)
                    }
                    .foregroundColor(isCopied ? .green : .accentColor)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.tertiarySystemBackground))

            // Code content
            ScrollView(.horizontal, showsIndicators: false) {
                Text(highlightedCode)
                    .font(.system(.footnote, design: .monospaced))
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }

    private var highlightedCode: AttributedString {
        var attributed = AttributedString(code)

        // Keywords
        let keywords = ["import", "struct", "class", "func", "var", "let", "if", "else", "for", "while", "return", "public", "private", "static", "enum", "case", "self", "init", "@State", "@Binding", "@Published", "@ObservableObject", "@Environment", "@EnvironmentObject", "some", "View", "true", "false", "nil"]

        for keyword in keywords {
            var searchRange = attributed.startIndex..<attributed.endIndex
            while let range = attributed[searchRange].range(of: keyword) {
                attributed[range].foregroundColor = .purple
                attributed[range].font = .system(.footnote, design: .monospaced).weight(.semibold)
                searchRange = range.upperBound..<attributed.endIndex
            }
        }

        // Strings
        var stringSearchRange = attributed.startIndex..<attributed.endIndex
        while let startRange = attributed[stringSearchRange].range(of: "\"") {
            let afterStart = startRange.upperBound
            if afterStart < attributed.endIndex,
               let endRange = attributed[afterStart..<attributed.endIndex].range(of: "\"") {
                let fullRange = startRange.lowerBound..<endRange.upperBound
                attributed[fullRange].foregroundColor = .red
                stringSearchRange = endRange.upperBound..<attributed.endIndex
            } else {
                break
            }
        }

        // Types (capitalized words)
        let typePattern = /[A-Z][a-zA-Z0-9]+/
        if let matches = try? typePattern.firstMatch(in: code) {
            // Basic type highlighting - in production, use proper regex
        }

        return attributed
    }

    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = code
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(code, forType: .string)
        #endif

        withAnimation {
            isCopied = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isCopied = false
            }
        }
    }
}

#if DEBUG
struct CodeSnippetView_Previews: PreviewProvider {
    static var previews: some View {
        CodeSnippetView(code: """
        import SwiftUI

        struct ContentView: View {
            @State private var isPressed = false

            var body: some View {
                DSButton("Click me", style: .primary) {
                    print("Button tapped!")
                }
            }
        }
        """)
        .padding()
    }
}
#endif
