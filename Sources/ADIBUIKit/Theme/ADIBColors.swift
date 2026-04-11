import SwiftUI

/// ADIB Design System Color Tokens
///
/// Auto-generated from Figma Style Guide.
/// Organized following the Figma token structure:
/// `color.<category>.<subcategory>.<variant>`
public enum ADIBColors {

    // MARK: - Semantic

    public enum Semantic {

        public enum Error {
            /// #7D0017 — Color used for errors
            public static let one = Color(hex: "#7D0017")
            /// #DA0027 — Color used for errors
            public static let two = Color(hex: "#DA0027")
            /// #FFEBEE — Color used for errors (light)
            public static let three = Color(hex: "#FFEBEE")
        }

        public enum Success {
            /// #005937 — Color used for success
            public static let one = Color(hex: "#005937")
            /// #008552 — Color used for success
            public static let two = Color(hex: "#008552")
            /// #E8FFF6 — Color used for success (light)
            public static let three = Color(hex: "#E8FFF6")
        }

        public enum Warning {
            /// #9E6300 — Color used for warning or pending states
            public static let one = Color(hex: "#9E6300")
            /// #FF9F00 — Color used for warning or pending states
            public static let two = Color(hex: "#FF9F00")
            /// #FFF5E3 — Color used for warning or pending states (light)
            public static let three = Color(hex: "#FFF5E3")
        }

        public enum Info {
            /// #004469 — Color used for informative use
            public static let one = Color(hex: "#004469")
            /// #0075B2 — Color used for informative use
            public static let two = Color(hex: "#0075B2")
            /// #EBF8FF — Color used for informative use (light)
            public static let three = Color(hex: "#EBF8FF")
        }
    }

    // MARK: - Primitive

    public enum Primitive {
        /// #FFFFFF — White color
        public static let white = Color(hex: "#FFFFFF")
        /// #000000 — Black color
        public static let black = Color(hex: "#000000")

        public enum Grey {
            /// #333333 — Grey color palette
            public static let one = Color(hex: "#333333")
            /// #757575 — Grey color palette
            public static let two = Color(hex: "#757575")
            /// #CCCCCC — Grey color palette
            public static let three = Color(hex: "#CCCCCC")
            /// #F2F2F2 — Grey color palette
            public static let four = Color(hex: "#F2F2F2")
            /// #FAFAFA — Grey color palette
            public static let five = Color(hex: "#FAFAFA")
        }
    }

    // MARK: - Interaction

    /// #006DD1 — Color used to show that an item is actionable
    public static let interaction = Color(hex: "#006DD1")

    // MARK: - Text

    public enum Text {
        /// #002B52 — Primary color used for all text
        public static let base = Color(hex: "#002B52")
        /// #69778C — Secondary color used for captions or sub headings
        public static let subdued = Color(hex: "#69778C")
        /// #FFFFFF — Color used when text is white on light mode
        public static let white = Color(hex: "#FFFFFF")
    }

    // MARK: - Background

    /// #FFFFFF — The main background color of the app
    public static let background = Color(hex: "#FFFFFF")

    // MARK: - Brand

    public enum Brand {

        public enum Primary {
            /// #003978 — Primary brand color for ADIB
            public static let one = Color(hex: "#003978")
            /// #0075B0 — Primary brand color for ADIB
            public static let two = Color(hex: "#0075B0")
            /// #EEF7FB — Primary brand color for ADIB (light)
            public static let three = Color(hex: "#EEF7FB")
        }

        public enum Secondary {
            /// #C6C6C5 — Secondary brand color for ADIB
            public static let one = Color(hex: "#C6C6C5")
            /// #8C704B — Secondary brand color for ADIB
            public static let two = Color(hex: "#8C704B")
            /// #00C1DE — Secondary brand color for ADIB
            public static let three = Color(hex: "#00C1DE")
        }
    }

    // MARK: - Button

    public enum Button {

        public enum Primary {
            /// #003978 — Background color for primary buttons (→ brand.primary.one)
            public static let background = Color(hex: "#003978")
            /// #FFFFFF — Text color for primary buttons
            public static let text = Color(hex: "#FFFFFF")
            /// #6284AA — Tapped state
            public static let tapped = Color(hex: "#6284AA")
            /// #C4CFDC — Disabled state
            public static let disabled = Color(hex: "#C4CFDC")
        }

        public enum Secondary {
            /// #006DD1 — Border color for secondary buttons (→ interaction)
            public static let border = Color(hex: "#006DD1")
            /// #006DD1 — Text color for secondary buttons (→ interaction)
            public static let text = Color(hex: "#006DD1")
            /// #62A8E8 — Tapped state
            public static let tapped = Color(hex: "#62A8E8")
            /// #C4DBF1 — Disabled state
            public static let disabled = Color(hex: "#C4DBF1")
        }

        public enum Small {
            /// #EBF4FD — Background for small buttons
            public static let background = Color(hex: "#EBF4FD")
            /// #006DD1 — Text color for small buttons
            public static let text = Color(hex: "#006DD1")
        }
    }

    // MARK: - Border

    /// #CCCCCC — Color used for all borders (→ primitive.grey.three)
    public static let border = Color(hex: "#CCCCCC")

    // MARK: - Input Fields

    public enum Inputs {
        /// #F2F5F7 — Background color for input fields (→ surface.components)
        public static let background = Color(hex: "#F2F5F7")
        /// #637185 — Placeholder text color
        public static let placeholder = Color(hex: "#637185")
    }

    // MARK: - Surface

    public enum Surface {
        /// #FFFFFF — Raised surface
        public static let raised = Color(hex: "#FFFFFF")
        /// #F2F5F7 — Background for input or control components
        public static let components = Color(hex: "#F2F5F7")
        /// #E0EBF0 — Used as accent background colors
        public static let blueOne = Color(hex: "#E0EBF0")
        /// #EEF7FB — Used as accent background colors
        public static let blueTwo = Color(hex: "#EEF7FB")
        /// #FFF5E3 — Used as accent background colors
        public static let yellow = Color(hex: "#FFF5E3")
        /// #EFF8F7 — Used as accent background colors
        public static let green = Color(hex: "#EFF8F7")
        /// #F6EFF8 — Used as accent background colors
        public static let purple = Color(hex: "#F6EFF8")
        /// #F7F3E9 — Used as accent background colors
        public static let gold = Color(hex: "#F7F3E9")
    }

    // MARK: - Gradients

    public enum Gradients {
        /// Linear gradient from #DCEFF5 to #32C4EE (45°)
        public static let one = LinearGradient(
            colors: [Color(hex: "#DCEFF5"), Color(hex: "#32C4EE")],
            startPoint: .bottomLeading, endPoint: .topTrailing
        )
        /// Linear gradient from #61C6EE to #009EDC (45°)
        public static let two = LinearGradient(
            colors: [Color(hex: "#61C6EE"), Color(hex: "#009EDC")],
            startPoint: .bottomLeading, endPoint: .topTrailing
        )
        /// Linear gradient from #1B1F52 to #3386C7 (45°)
        public static let three = LinearGradient(
            colors: [Color(hex: "#1B1F52"), Color(hex: "#3386C7")],
            startPoint: .bottomLeading, endPoint: .topTrailing
        )
    }

    // MARK: - Charts / Graphs

    public enum Charts {
        /// #6B90F7
        public static let blue = Color(hex: "#6B90F7")
        /// #7363E8
        public static let purple = Color(hex: "#7363E8")
        /// #CA3B7D
        public static let pink = Color(hex: "#CA3B7D")
        /// #ED6A2C
        public static let orange = Color(hex: "#ED6A2C")
        /// #F4B23E
        public static let yellow = Color(hex: "#F4B23E")
    }

    // MARK: - Segment

    public enum Segment {
        /// #EEF7FB — Segment surface
        public static let surface = Color(hex: "#EEF7FB")
        /// #0EA4DF — Segment accent
        public static let accent = Color(hex: "#0EA4DF")

        public enum Gold {
            /// #5C4C25
            public static let one = Color(hex: "#5C4C25")
            /// #94703D
            public static let two = Color(hex: "#94703D")
            /// #F7F3E9
            public static let three = Color(hex: "#F7F3E9")
        }

        public enum Diamond {
            /// #333333
            public static let one = Color(hex: "#333333")
            /// #575757
            public static let two = Color(hex: "#575757")
            /// #F2F5F7
            public static let three = Color(hex: "#F2F5F7")
        }

        public enum Mass {
            /// #0EA4DF
            public static let one = Color(hex: "#0EA4DF")
            /// #EEF7FB
            public static let two = Color(hex: "#EEF7FB")
        }
    }

    // MARK: - Blue Background

    public enum BlueBackground {
        /// #5985CB — Input background on blue
        public static let inputBackground = Color(hex: "#5985CB")
        /// #1F5FB5 — Disabled button on blue
        public static let buttonDisabled = Color(hex: "#1F5FB5")
        /// #9BB9EA — Disabled button text on blue
        public static let buttonDisabledText = Color(hex: "#9BB9EA")
    }

    // MARK: - Banners

    public enum Banners {

        public enum Info {
            /// #EBF8FF — Info banner background (→ semantic.info.three)
            public static let background = Color(hex: "#EBF8FF")
            /// #E2F1F9 — Info banner button
            public static let buttons = Color(hex: "#E2F1F9")
        }

        public enum Success {
            /// #E8FFF6 — Success banner background (→ semantic.success.three)
            public static let background = Color(hex: "#E8FFF6")
            /// #DFF8F0 — Success banner button
            public static let buttons = Color(hex: "#DFF8F0")
        }

        public enum Error {
            /// #FFEBEE — Error banner background (→ semantic.error.three)
            public static let background = Color(hex: "#FFEBEE")
            /// #FAE2E5 — Error banner button
            public static let buttons = Color(hex: "#FAE2E5")
        }

        public enum Warning {
            /// #FFF5E3 — Warning banner background (→ semantic.warning.three)
            public static let background = Color(hex: "#FFF5E3")
            /// #FBEFDA — Warning banner button
            public static let buttons = Color(hex: "#FBEFDA")
        }
    }
}
