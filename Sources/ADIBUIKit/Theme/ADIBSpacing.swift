import SwiftUI

/// ADIB Design System Spacing Tokens
public enum ADIBSpacing {
    /// 20pt — Default horizontal screen padding
    public static let screenHorizontal: CGFloat = 20
}

// MARK: - View Modifier

extension View {
    /// Applies the default ADIB screen padding (20pt left & right).
    ///
    /// ```swift
    /// VStack {
    ///     Text("Hello")
    /// }
    /// .adibScreenPadding()
    /// ```
    public func adibScreenPadding() -> some View {
        self.padding(.horizontal, ADIBSpacing.screenHorizontal)
    }
}
