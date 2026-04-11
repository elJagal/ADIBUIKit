import SwiftUI

/// ADIB Design System Typography Tokens
///
/// Auto-generated from Figma Style Guide.
/// All styles use the iOS system font (SF Pro).
///
/// Naming: `ADIBTypography.<style>.<weight>`
/// e.g. `ADIBTypography.h1.regular`, `ADIBTypography.body.semibold`
public enum ADIBTypography {

    // MARK: - Large Title (44pt)

    public enum largeTitle {
        /// 44pt / Heavy / line-height 46 / tracking -0.15
        public static let heavy = ADIBFont(size: 44, weight: .heavy, lineHeight: 46, tracking: -0.15)
    }

    // MARK: - H1 (32pt)

    public enum h1 {
        /// 32pt / Regular / line-height 41 / tracking 0.38
        public static let regular = ADIBFont(size: 32, weight: .regular, lineHeight: 41, tracking: 0.38)
        /// 32pt / Semibold / line-height 41 / tracking 0.38
        public static let semibold = ADIBFont(size: 32, weight: .semibold, lineHeight: 41, tracking: 0.38)
    }

    // MARK: - H2 (28pt)

    public enum h2 {
        /// 28pt / Regular / line-height 34 / tracking 0.36
        public static let regular = ADIBFont(size: 28, weight: .regular, lineHeight: 34, tracking: 0.36)
        /// 28pt / Semibold / line-height 34 / tracking 0.36
        public static let semibold = ADIBFont(size: 28, weight: .semibold, lineHeight: 34, tracking: 0.36)
    }

    // MARK: - H3 (24pt)

    public enum h3 {
        /// 24pt / Regular / line-height 28 / tracking 0.36
        public static let regular = ADIBFont(size: 24, weight: .regular, lineHeight: 28, tracking: 0.36)
        /// 24pt / Semibold / line-height 28 / tracking 0.36
        public static let semibold = ADIBFont(size: 24, weight: .semibold, lineHeight: 28, tracking: 0.36)
    }

    // MARK: - H4 (20pt)

    public enum h4 {
        /// 20pt / Regular / line-height 25 / tracking 0.38
        public static let regular = ADIBFont(size: 20, weight: .regular, lineHeight: 25, tracking: 0.38)
        /// 20pt / Semibold / line-height 25 / tracking 0.38
        public static let semibold = ADIBFont(size: 20, weight: .semibold, lineHeight: 25, tracking: 0.38)
    }

    // MARK: - Body (16pt)

    public enum body {
        /// 16pt / Regular / line-height 22 / tracking -0.32
        public static let regular = ADIBFont(size: 16, weight: .regular, lineHeight: 22, tracking: -0.32)
        /// 16pt / Semibold / line-height 22 / tracking -0.32
        public static let semibold = ADIBFont(size: 16, weight: .semibold, lineHeight: 22, tracking: -0.32)
    }

    // MARK: - Caption (14pt)

    public enum caption {
        /// 14pt / Regular / line-height 18 / tracking -0.15
        public static let regular = ADIBFont(size: 14, weight: .regular, lineHeight: 18, tracking: -0.15)
        /// 14pt / Semibold / line-height 18 / tracking -0.15
        public static let semibold = ADIBFont(size: 14, weight: .semibold, lineHeight: 18, tracking: -0.15)
    }
}

// MARK: - Font Token

/// A typography token holding all values needed to style text.
public struct ADIBFont {
    public let size: CGFloat
    public let weight: Font.Weight
    public let lineHeight: CGFloat
    public let tracking: CGFloat

    /// The SwiftUI `Font` for this token.
    public var font: Font {
        .system(size: size, weight: weight)
    }

    /// Line spacing = lineHeight − fontSize
    public var lineSpacing: CGFloat {
        lineHeight - size
    }
}

// MARK: - View Modifier

/// Applies a full ADIB typography style (font, tracking, line spacing, and text color).
public struct ADIBTextStyle: ViewModifier {
    let token: ADIBFont
    let color: Color

    public func body(content: Content) -> some View {
        content
            .font(token.font)
            .kerning(token.tracking)
            .lineSpacing(token.lineSpacing)
            .foregroundStyle(color)
    }
}

extension View {
    /// Apply an ADIB typography token to this view.
    ///
    /// ```swift
    /// Text("Hello")
    ///     .adibTextStyle(ADIBTypography.h1.semibold)
    /// ```
    public func adibTextStyle(_ token: ADIBFont, color: Color = ADIBColors.Text.base) -> some View {
        modifier(ADIBTextStyle(token: token, color: color))
    }
}
