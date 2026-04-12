import SwiftUI

/// ADIB Design System Color Tokens
///
/// Backed by `DesignTokens.xcassets` asset catalog which provides
/// automatic Light/Dark mode support via Xcode appearance variants.
///
/// Organized following the Figma token structure:
/// `color.<category>.<subcategory>.<variant>`
public enum ADIBColors {

    // MARK: - Semantic

    public enum Semantic {

        public enum Error {
            public static let one = Color("colorSemanticErrorOne", bundle: .module)
            public static let two = Color("colorSemanticErrorTwo", bundle: .module)
            public static let three = Color("colorSemanticErrorThree", bundle: .module)
        }

        public enum Success {
            public static let one = Color("colorSemanticSuccessOne", bundle: .module)
            public static let two = Color("colorSemanticSuccessTwo", bundle: .module)
            public static let three = Color("colorSemanticSuccessThree", bundle: .module)
        }

        public enum Warning {
            public static let one = Color("colorSemanticWarningOne", bundle: .module)
            public static let two = Color("colorSemanticWarningTwo", bundle: .module)
            public static let three = Color("colorSemanticWarningThree", bundle: .module)
        }

        public enum Info {
            public static let one = Color("colorSemanticInfoOne", bundle: .module)
            public static let two = Color("colorSemanticInfoTwo", bundle: .module)
            public static let three = Color("colorSemanticInfoThree", bundle: .module)
        }

        /// Fraud indicator color
        public static let fraud = Color("colorSemanticFraud", bundle: .module)
    }

    // MARK: - Primitive

    public enum Primitive {
        public static let white = Color("colorPrimitiveWhite", bundle: .module)
        public static let black = Color("colorPrimitiveBlack", bundle: .module)

        public enum Grey {
            public static let one = Color("colorPrimitiveGreyOne", bundle: .module)
            public static let two = Color("colorPrimitiveGreyTwo", bundle: .module)
            public static let three = Color("colorPrimitiveGreyThree", bundle: .module)
            public static let four = Color("colorPrimitiveGreyFour", bundle: .module)
            public static let five = Color("colorPrimitiveGreyFive", bundle: .module)
        }
    }

    // MARK: - Interaction

    public static let interaction = Color("colorInteraction", bundle: .module)

    // MARK: - Text

    public enum Text {
        public static let base = Color("colorTextBase", bundle: .module)
        public static let subdued = Color("colorTextSubdued", bundle: .module)
        public static let white = Color("colorTextWhite", bundle: .module)
    }

    // MARK: - Background

    public static let background = Color("colorBackground", bundle: .module)

    // MARK: - Brand

    public enum Brand {

        public enum Primary {
            public static let one = Color("colorBrandPrimaryOne", bundle: .module)
            public static let two = Color("colorBrandPrimaryTwo", bundle: .module)
            public static let three = Color("colorBrandPrimaryThree", bundle: .module)
        }

        public enum Secondary {
            public static let one = Color("colorBrandSecondaryOne", bundle: .module)
            public static let two = Color("colorBrandSecondaryTwo", bundle: .module)
            public static let three = Color("colorBrandSecondaryThree", bundle: .module)
        }
    }

    // MARK: - Button

    public enum Button {

        public enum Primary {
            public static let background = Color("colorButtonPrimaryBackground", bundle: .module)
            public static let text = Color("colorButtonPrimaryText", bundle: .module)
            public static let tapped = Color("colorButtonPrimaryTapped", bundle: .module)
            public static let disabled = Color("colorButtonPrimaryDisabled", bundle: .module)
        }

        public enum Secondary {
            public static let border = Color("colorButtonSecondaryBorder", bundle: .module)
            public static let text = Color("colorButtonSecondaryText", bundle: .module)
            public static let tapped = Color("colorButtonSecondaryTapped", bundle: .module)
            public static let disabled = Color("colorButtonSecondaryDisabled", bundle: .module)
        }

        public enum Small {
            public static let background = Color("colorButtonSmallBackground", bundle: .module)
            public static let text = Color("colorButtonSmallText", bundle: .module)
        }

        public enum Tertiary {
            public static let `default` = Color("colorButtonTertiaryDefault", bundle: .module)
            public static let tapped = Color("colorButtonTertiaryTapped", bundle: .module)
            public static let disabled = Color("colorButtonTertiaryDisabled", bundle: .module)
        }
    }

    // MARK: - Border

    public static let border = Color("colorBorder", bundle: .module)

    // MARK: - Input Fields

    public enum Inputs {
        public static let background = Color("colorInputsBackground", bundle: .module)
        public static let placeholder = Color("colorInputsPlaceholder", bundle: .module)
    }

    // MARK: - Surface

    public enum Surface {
        public static let raised = Color("colorSurfaceRaised", bundle: .module)
        public static let components = Color("colorSurfaceComponents", bundle: .module)
        public static let blueOne = Color("colorSurfaceBlueOne", bundle: .module)
        public static let blueTwo = Color("colorSurfaceBlueTwo", bundle: .module)
        public static let yellow = Color("colorSurfaceYellow", bundle: .module)
        public static let green = Color("colorSurfaceGreen", bundle: .module)
        public static let purple = Color("colorSurfacePurple", bundle: .module)
        public static let goldOne = Color("colorSurfaceGoldOne", bundle: .module)
        public static let goldTwo = Color("colorSurfaceGoldTwo", bundle: .module)
        public static let diamondOne = Color("colorSurfaceDiamondOne", bundle: .module)
        public static let diamondTwo = Color("colorSurfaceDiamondTwo", bundle: .module)
        public static let privateOne = Color("colorSurfacePrivateOne", bundle: .module)
        public static let privateTwo = Color("colorSurfacePrivateTwo", bundle: .module)
    }

    // MARK: - Gradients

    public enum Gradients {
        public static let one = Color("colorGradientsOne", bundle: .module)
        public static let two = Color("colorGradientsTwo", bundle: .module)
        public static let three = Color("colorGradientsThree", bundle: .module)

        public enum Palette {
            public static let blueOne = Color("colorGradientsPaletteBlueOne", bundle: .module)
            public static let blueTwo = Color("colorGradientsPaletteBlueTwo", bundle: .module)
        }

        public enum Colors {
            public static let oneStart = Color("colorGradientsColorsOneStart", bundle: .module)
            public static let oneEnd = Color("colorGradientsColorsOneEnd", bundle: .module)
            public static let twoStart = Color("colorGradientsColorsTwoStart", bundle: .module)
            public static let twoEnd = Color("colorGradientsColorsTwoEnd", bundle: .module)
        }

        /// Convenience LinearGradient builders
        public static var gradientOne: LinearGradient {
            LinearGradient(
                colors: [Colors.oneStart, Colors.oneEnd],
                startPoint: .bottomLeading, endPoint: .topTrailing
            )
        }

        public static var gradientTwo: LinearGradient {
            LinearGradient(
                colors: [Colors.twoStart, Colors.twoEnd],
                startPoint: .bottomLeading, endPoint: .topTrailing
            )
        }

        /// Blue palette gradient — 136° (#3773D4 → #2A57A1)
        /// Used for story circle backgrounds
        public static var gradientPaletteBlue: LinearGradient {
            LinearGradient(
                colors: [Palette.blueTwo, Palette.blueOne],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }

        public enum StoryRing {
            public static let start = Color("colorGradientsStoryRingStart", bundle: .module)
            public static let end = Color("colorGradientsStoryRingEnd", bundle: .module)
        }

        /// Story ring gradient — -136° (#DCEFF5 → #32C4EE)
        /// Used for the outer stroke ring on unseen stories
        public static var gradientStoryRing: LinearGradient {
            LinearGradient(
                colors: [StoryRing.start, StoryRing.end],
                startPoint: .bottomTrailing, endPoint: .topLeading
            )
        }
    }

    // MARK: - Charts / Graphs

    public enum Charts {
        public static let blue = Color("colorChartsBlue", bundle: .module)
        public static let purple = Color("colorChartsPurple", bundle: .module)
        public static let pink = Color("colorChartsPink", bundle: .module)
        public static let orange = Color("colorChartsOrange", bundle: .module)
        public static let yellow = Color("colorChartsYellow", bundle: .module)
    }

    // MARK: - Segment

    public enum Segment {
        public static let surface = Color("colorSegmentSurface", bundle: .module)
        public static let accent = Color("colorSegmentAccent", bundle: .module)

        public enum Gold {
            public static let one = Color("colorSegmentGoldOne", bundle: .module)
            public static let two = Color("colorSegmentGoldTwo", bundle: .module)
            public static let three = Color("colorSegmentGoldThree", bundle: .module)
        }

        public enum Diamond {
            public static let one = Color("colorSegmentDiamondOne", bundle: .module)
            public static let two = Color("colorSegmentDiamondTwo", bundle: .module)
            public static let three = Color("colorSegmentDiamondThree", bundle: .module)
        }

        public enum Mass {
            public static let one = Color("colorSegmentMassOne", bundle: .module)
            public static let two = Color("colorSegmentMassTwo", bundle: .module)
        }

        public static let privateGoldText = Color("colorSegmentPrivateGoldtext", bundle: .module)
    }

    // MARK: - Banners

    public enum Banners {

        public enum Info {
            public static let background = Color("colorBannersInfoBg", bundle: .module)
            public static let buttons = Color("colorBannersInfoButtons", bundle: .module)
        }

        public enum Success {
            public static let background = Color("colorBannersSuccessBg", bundle: .module)
            public static let buttons = Color("colorBannersSuccessButtons", bundle: .module)
        }

        public enum Error {
            public static let background = Color("colorBannersErrorBg", bundle: .module)
            public static let buttons = Color("colorBannersErrorButtons", bundle: .module)
        }

        public enum Warning {
            public static let background = Color("colorBannersWarningBg", bundle: .module)
            public static let buttons = Color("colorBannersWarningButtons", bundle: .module)
        }
    }

    // MARK: - Blue Background

    public enum BlueBackground {
        public static let inputBackground = Color("colorBlueBackgroundInputBackground", bundle: .module)
        public static let buttonDisabled = Color("colorBlueBackgroundButtonDisabled", bundle: .module)
        public static let buttonDisabledText = Color("colorBlueBackgroundButtonDisabledText", bundle: .module)
    }

    // MARK: - Home Theme

    public enum HomeTheme {
        public static let gradientBgOne = Color("colorHomeThemeGradientBgOne", bundle: .module)
        public static let gradientBgTwo = Color("colorHomeThemeGradientBgTwo", bundle: .module)
        public static let androidBar = Color("colorHomeThemeAndroidBar", bundle: .module)
        public static let profileIcon = Color("colorHomeThemeProfileIcon", bundle: .module)
        public static let loyaltyBackground = Color("colorHomeThemeLoyaltyBackground", bundle: .module)
        public static let loyaltyText = Color("colorHomeThemeLoyaltyText", bundle: .module)
        public static let iconsHeader = Color("colorHomeThemeIconsHeader", bundle: .module)
        public static let iconsBalance = Color("colorHomeThemeIconsBalance", bundle: .module)
        public static let bannerSurface = Color("colorHomeThemeBannerSurface", bundle: .module)
        public static let bannerText = Color("colorHomeThemeBannerText", bundle: .module)
    }
}
