// Prints the CGWindowID of the first on-screen normal window owned by the named app.
import CoreGraphics
import Foundation
let name = CommandLine.arguments.dropFirst().first ?? ""
let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? []
for w in list where (w[kCGWindowOwnerName as String] as? String) == name && (w[kCGWindowLayer as String] as? Int) == 0 {
    if let b = w[kCGWindowBounds as String] as? [String: CGFloat], (b["Height"] ?? 0) > 200 { print(w[kCGWindowNumber as String] as? Int ?? 0); break }
}
