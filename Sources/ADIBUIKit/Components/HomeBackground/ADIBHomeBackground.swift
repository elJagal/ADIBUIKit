import SwiftUI

// MARK: - Home Background Theme

/// The visual theme for the home background.
/// Default is `.white`. Each segment (mass, gold, diamond, private) can have its own theme.
public enum ADIBHomeBackgroundTheme {
    /// Default white background
    case white
    /// Mass segment — dark blue background with texture overlay
    case mass
}

// MARK: - Home Background

/// A layered home background component with multiple visual layers.
///
/// Layers (bottom to top):
/// 1. **Base color** — solid fill
/// 2. **Texture overlay** — image with soft-light blend mode
/// 3. **Top gradient** — dark fade from the top edge
/// 4. **Content** — your views go here
/// 5. **Bottom blur** — frosted transition to the content below
///
/// ```swift
/// ADIBHomeBackground(theme: .mass, textureImage: Image("home-texture")) {
///     // Your content here
/// }
/// ```
public struct ADIBHomeBackground<Content: View>: View {

    // MARK: - Properties

    private let theme: ADIBHomeBackgroundTheme
    private let textureImage: Image?
    private let coloredHeight: CGFloat
    private let content: Content

    // MARK: - Constants

    private let blurHeight: CGFloat = 92
    private let topGradientHeight: CGFloat = 78

    /// Total component height = colored area + half of blur (extending into white)
    private var totalHeight: CGFloat {
        coloredHeight + blurHeight / 2
    }

    // MARK: - Init

    /// Creates a layered home background.
    /// - Parameters:
    ///   - theme: The background theme (default `.white`)
    ///   - textureImage: Optional texture image for the overlay layer
    ///   - coloredHeight: Height of the colored background area (default 389pt)
    ///   - content: The content to display on the background
    public init(
        theme: ADIBHomeBackgroundTheme = .white,
        textureImage: Image? = nil,
        coloredHeight: CGFloat = 389,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.textureImage = textureImage
        self.coloredHeight = coloredHeight
        self.content = content()
    }

    // MARK: - Gradient Angle

    /// Convert 39° to SwiftUI UnitPoints
    /// 39° → approximately startPoint(0.18, 0.82) endPoint(0.82, 0.18)
    private var gradientStart: UnitPoint {
        UnitPoint(x: 0.18, y: 0.82)
    }

    private var gradientEnd: UnitPoint {
        UnitPoint(x: 0.82, y: 0.18)
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .top) {
            // Layer 1: Base color (389pt)
            baseLayer

            // Layer 2: Texture overlay (389pt)
            textureLayer

            // Layer 3: Top gradient (78pt)
            topGradientLayer

            // Layer 4: Bottom blur — straddles the boundary between dark and white
            bottomBlurLayer

            // Layer 5: Content
            content
        }
        .frame(maxWidth: .infinity)
        .frame(height: totalHeight)
    }

    // MARK: - Layer 1: Base Color

    @ViewBuilder
    private var baseLayer: some View {
        VStack {
            Group {
                switch theme {
                case .white:
                    ADIBColors.background
                case .mass:
                    ADIBColors.Text.base
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: coloredHeight)
            Spacer()
        }
    }

    // MARK: - Layer 2: Texture Overlay
    //
    // 3-stop linear gradient at 39° with soft-light blend on top of base:
    // 0%: #000000 70% → 50%: #FFFFFF 70% → 100%: #000000 70%
    // If a custom textureImage is provided, it is used instead.

    @ViewBuilder
    private var textureLayer: some View {
        switch theme {
        case .white:
            EmptyView()

        case .mass:
            VStack {
                Group {
                    if let textureImage {
                        textureImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blendMode(.softLight)
                    } else {
                        LinearGradient(
                            stops: [
                                .init(color: Color.black.opacity(0.7), location: 0),
                                .init(color: Color.white.opacity(0.7), location: 0.5),
                                .init(color: Color.black.opacity(0.7), location: 1.0)
                            ],
                            startPoint: gradientStart,
                            endPoint: gradientEnd
                        )
                        .blendMode(.softLight)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: coloredHeight)
                .clipped()
                Spacer()
            }
        }
    }

    // MARK: - Layer 3: Top Gradient

    @ViewBuilder
    private var topGradientLayer: some View {
        switch theme {
        case .white:
            EmptyView()

        case .mass:
            LinearGradient(
                colors: [ADIBColors.HomeTheme.massGradient, ADIBColors.HomeTheme.massGradient.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity)
            .frame(height: topGradientHeight)
        }
    }

    // MARK: - Layer 4: Bottom Blur Transition
    //
    // 92pt tall image, centered at the 389pt boundary.
    // Exported from Figma as a pre-rendered blur image.

    @ViewBuilder
    private var bottomBlurLayer: some View {
        if theme != .white {
            Image("home-blur-transition", bundle: .module)
                .offset(y: coloredHeight - blurHeight / 2)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ADIBHomeBackground_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                ADIBHomeBackground(theme: .mass) {
                    VStack {
                        Text("Home Content")
                            .foregroundStyle(.white)
                            .padding(.top, 100)
                    }
                }

                Spacer()
            }
        }
        .background(ADIBColors.background)
        .ignoresSafeArea()
    }
}
#endif
