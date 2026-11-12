import SwiftUI
import BraisenlySwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct SnippetPane: View {
    let title: String
    let code: String
    let onCopied: () -> Void

    var body: some View {
        BraisenlySectionHeader("Code", systemImage: "chevron.left.forwardslash.chevron.right")
        BraisenlyCodeBlockCard(language: "swift", code: code) {
            #if os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(code, forType: .string)
            #else
            UIPasteboard.general.string = code
            #endif
            onCopied()
        }
        .accessibilityIdentifier("catalog.snippet")
        .accessibilityLabel("Code for \(title)")
    }
}
