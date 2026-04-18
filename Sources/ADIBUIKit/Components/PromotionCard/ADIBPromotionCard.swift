import SwiftUI

// MARK: - Promotion Card Segment

/// The segment theme for the promotion card.
/// Each segment defines its own background and text color.
/// New segments (e.g. gold, diamond) can be added in the future.
public enum ADIBPromotionCardSegment {
    /// Mass segment — semi-transparent white background, white text.
    /// Used on dark/gradient backgrounds.
    case mass

    /// Mass Blue segment — Surface.blueTwo background, dark text.
    /// Used on light backgrounds.
    case massBlue

    /// The card background color for this segment.
    var backgroundColor: Color {
        switch self {
        case .mass:     return Color.white.opacity(0.15)
        case .massBlue: return ADIBColors.Surface.blueTwo
        }
    }

    /// The text color for this segment.
    var textColor: Color {
        switch self {
        case .mass:     return ADIBColors.Text.white
        case .massBlue: return ADIBColors.Text.base
        }
    }
}

// MARK: - Promotion Card Component

/// A promotion banner card with a card image on the left and text content on the right.
///
/// Supports multiple segment themes for different backgrounds.
///
/// ```swift
/// // Mass segment — on dark backgrounds
/// ADIBPromotionCard(
///     segment: .mass,
///     image: Image("covered-card"),
///     title: "Get a Covered Card",
///     description: "You are eligible to apply for a Covered Card. Tap here to get started!"
/// )
///
/// // Mass Blue segment — on light backgrounds
/// ADIBPromotionCard(
///     segment: .massBlue,
///     image: Image("covered-card"),
///     title: "Promotional banner",
///     description: "You can add no more than three lines of content in this banner."
/// )
/// ```
public struct ADIBPromotionCard: View {

    // MARK: - Properties

    private let segment: ADIBPromotionCardSegment
    private let image: Image
    private let title: String
    private let description: String
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let cardHeight: CGFloat = 115
    private let cardRadius: CGFloat = ADIBSizes.Radius.medium                  // 16
    private let cardImageWidth: CGFloat = 97
    private let textLeading: CGFloat = 109.5
    private let textTop: CGFloat = 18
    private let textWidth: CGFloat = 187
    private let textGap: CGFloat = ADIBSizes.Spacing.xsmall                    // 4

    // MARK: - Init

    /// Creates a promotion card.
    /// - Parameters:
    ///   - segment: The segment theme (default `.mass`).
    ///   - image: The promotional image (e.g. a credit card image).
    ///   - title: The promotion title text.
    ///   - description: The promotion description text.
    ///   - onTap: Optional tap action for the card.
    public init(
        segment: ADIBPromotionCardSegment = .mass,
        image: Image,
        title: String,
        description: String,
        onTap: (() -> Void)? = nil
    ) {
        self.segment = segment
        self.image = image
        self.title = title
        self.description = description
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button {
            onTap?()
        } label: {
            ZStack(alignment: .topLeading) {
                // Card background
                RoundedRectangle(cornerRadius: cardRadius)
                    .fill(segment.backgroundColor)
                    .frame(height: cardHeight)

                // Card image — flush left, vertically centred
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardImageWidth, height: cardHeight)
                    .clipped()

                // Text content — right of image
                VStack(alignment: .leading, spacing: textGap) {
                    Text(title)
                        .adibTextStyle(ADIBTypography.body.semibold, color: segment.textColor)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(description)
                        .adibTextStyle(ADIBTypography.caption.regular, color: segment.textColor)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: textWidth, alignment: .leading)
                .padding(.leading, textLeading)
                .padding(.top, textTop)
            }
            .frame(maxWidth: .infinity)
            .frame(height: cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: cardRadius))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Mass Blue Segment") {
    ADIBPromotionCard(
        segment: .massBlue,
        image: Image(systemName: "creditcard.fill"),
        title: "Promotional banner",
        description: "You can add no more than three lines of content in this banner."
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Mass Segment — Dark Background") {
    ZStack {
        ADIBColors.Text.base
            .ignoresSafeArea()

        ADIBPromotionCard(
            segment: .mass,
            image: Image(systemName: "creditcard.fill"),
            title: "Get a Covered Card",
            description: "You are eligible to apply for a Covered Card. Tap here to get started!"
        )
        .padding(.horizontal, ADIBSizes.Spacing.medium)
    }
}
#endif
