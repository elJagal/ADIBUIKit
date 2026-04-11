import SwiftUI

/// ADIB Design System Size Tokens
///
/// Auto-generated from Figma Style Guide.
/// Includes spacing, font sizes, radii, and button heights.
public enum ADIBSizes {

    // MARK: - Spacing

    public enum Spacing {
        public static let xxxlarge: CGFloat = 64
        public static let xxlarge: CGFloat = 40
        public static let xlarge: CGFloat = 32
        public static let large: CGFloat = 24
        public static let medium: CGFloat = 16
        public static let small: CGFloat = 8
        public static let xsmall: CGFloat = 4
        public static let xxsmall: CGFloat = 2
    }

    // MARK: - Font Sizes

    public enum Font {
        public static let largeTitle: CGFloat = 44
        public static let nine: CGFloat = 52
        public static let eight: CGFloat = 36
        public static let seven: CGFloat = 32
        public static let six: CGFloat = 28
        public static let five: CGFloat = 24
        public static let four: CGFloat = 20
        public static let three: CGFloat = 16
        public static let two: CGFloat = 14
        public static let one: CGFloat = 12
        /// 10pt — Used for tab bar labels
        public static let tabLabel: CGFloat = 10

        // Mobile aliases
        public static let mobileH1: CGFloat = seven      // 32
        public static let mobileH2: CGFloat = six        // 28
        public static let mobileH3: CGFloat = five       // 24
        public static let mobileH4: CGFloat = four       // 20
        public static let mobileBody: CGFloat = three    // 16
        public static let mobileCaption: CGFloat = two   // 14
        public static let mobileLargeTitle: CGFloat = largeTitle // 44
    }

    // MARK: - Radius

    public enum Radius {
        public static let `default`: CGFloat = 20
        public static let medium: CGFloat = 16
        public static let small: CGFloat = 12
        public static let card: CGFloat = `default` // 20
    }

    // MARK: - Button Heights

    public enum ButtonHeight {
        public static let base: CGFloat = 54
        public static let primary: CGFloat = base
        public static let secondary: CGFloat = base
        public static let tertiary: CGFloat = base
    }
}
