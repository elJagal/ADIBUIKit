import SwiftUI

/// A promotion banner card with a card image on the left and text content on the right.
///
/// Designed to be placed on dark or gradient backgrounds — uses a semi-transparent white overlay.
///
/// ```swift
/// ADIBPromotionCard(
///     image: Image("covered-card"),
///     title: "Get a Covered Card",
///     description: "You are eligible to apply for a Covered Card. Tap here to get started!"
/// )
/// ```
public struct ADIBPromotionCard: View {

    // MARK: - Properties

    private let image: Image
    private let title: String
    private let description: String
    private let onTap: (() -> Void)?

    // MARK: - Constants

    /// 20pt padding — between medium(16) and large(24), as per Figma spec
    private let cardPadding: CGFloat = 20
    private let cardImageWidth: CGFloat = 97
    private let cardImageHeight: CGFloat = 115

    // MARK: - Init

    /// Creates a promotion card.
    /// - Parameters:
    ///   - image: The promotional image (e.g. a credit card image)
    ///   - title: The promotion title text
    ///   - description: The promotion description text
    ///   - onTap: Optional tap action for the card
    public init(
        image: Image,
        title: String,
        description: String,
        onTap: (() -> Void)? = nil
    ) {
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
            HStack(spacing: 0) {
                // Card image — flush to the left edge, vertically centered, rotated
                cardImageView

                // Text content — right side
                textContentView

                Spacer(minLength: 0)
            }
            .padding(.trailing, cardPadding)
            // No left padding — image is flush to the left edge
            .frame(maxWidth: .infinity, minHeight: cardImageHeight)
            .background(Color.white.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: ADIBSizes.Radius.medium))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Subviews

    private var cardImageView: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: cardImageWidth, height: cardImageHeight)
            .clipped()
    }

    private var textContentView: some View {
        VStack(alignment: .leading, spacing: ADIBSizes.Spacing.xsmall) {
            Text(title)
                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.white)
                .fixedSize(horizontal: false, vertical: true)

            Text(description)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.leading, ADIBSizes.Spacing.small)
    }
}

// MARK: - Preview

#if DEBUG
struct ADIBPromotionCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ADIBColors.Text.base
                .ignoresSafeArea()

            ADIBPromotionCard(
                image: Image(systemName: "creditcard.fill"),
                title: "Get a Covered Card",
                description: "You are eligible to apply for a Covered Card. Tap here to get started!"
            )
            .padding(.horizontal, ADIBSizes.Spacing.medium)
        }
    }
}
#endif
