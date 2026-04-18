import SwiftUI

// MARK: - Promotion Size

/// The size variant for the promotion component.
public enum ADIBPromotionSize {
    /// Large banner: heading + product image on top card, call-to-action text below.
    /// Height 150pt, inner card 108pt.
    case large

    /// Small compact: 60×60 image + heading + description in a row.
    case small
}

// MARK: - Promotion Component

/// A promotional card component from the ADIB design system.
///
/// Two size variants matching Figma:
///
/// ```swift
/// // Large — heading + product image + call-to-action
/// ADIBPromotion(
///     size: .large,
///     image: Image("covered-card"),
///     heading: "Promotional heading goes here in three lines",
///     callToAction: "👏🏽 Text with a call to action",
///     onTap: { }
/// )
///
/// // Small — image thumbnail + heading + description
/// ADIBPromotion(
///     size: .small,
///     image: Image("starbucks"),
///     heading: "Promotional heading here",
///     description: "Description here. Max two lines of content goes here.",
///     onTap: { }
/// )
/// ```
public struct ADIBPromotion: View {

    // MARK: - Properties

    private let size: ADIBPromotionSize
    private let image: Image
    private let heading: String
    private let description: String?
    private let callToAction: String?
    private let onTap: (() -> Void)?

    // MARK: - Constants (Large)

    private let largeContainerHeight: CGFloat = 150
    private let largeContainerRadius: CGFloat = ADIBSizes.Radius.medium         // 16
    private let largeInnerHeight: CGFloat = 108
    private let largeInnerRadius: CGFloat = 10
    private let largeHeadingLeading: CGFloat = 20
    private let largeHeadingTop: CGFloat = 20
    private let largeHeadingWidth: CGFloat = 188
    private let largeImageSize: CGFloat = 115
    private let largeImageTrailing: CGFloat = 12                                // 335 - 208 - 115 = 12
    private let largeImageTop: CGFloat = 14
    private let largeCTATop: CGFloat = 120

    // MARK: - Constants (Small)

    private let smallContainerRadius: CGFloat = ADIBSizes.Radius.medium         // 16
    private let smallPadding: CGFloat = ADIBSizes.Spacing.small                 // 8
    private let smallImageSize: CGFloat = 60
    private let smallImageRadius: CGFloat = ADIBSizes.Radius.small              // 12
    private let smallContentGap: CGFloat = 12
    private let smallTextGap: CGFloat = ADIBSizes.Spacing.xxsmall              // 2

    // MARK: - Init

    /// Creates a promotion component.
    /// - Parameters:
    ///   - size: The promotion size variant (default `.large`).
    ///   - image: The promotional image (product image for large, thumbnail for small).
    ///   - heading: The heading text.
    ///   - description: The description text (used in `.small` variant).
    ///   - callToAction: The call-to-action text (used in `.large` variant).
    ///   - onTap: Optional tap action.
    public init(
        size: ADIBPromotionSize = .large,
        image: Image,
        heading: String,
        description: String? = nil,
        callToAction: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.size = size
        self.image = image
        self.heading = heading
        self.description = description
        self.callToAction = callToAction
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button {
            onTap?()
        } label: {
            switch size {
            case .large:
                largeLayout
            case .small:
                smallLayout
            }
        }
        .buttonStyle(.plain)
    }

    // =========================================================================
    // MARK: - Large Layout
    // =========================================================================

    /// Heading + product image on a card, call-to-action text below.
    private var largeLayout: some View {
        ZStack(alignment: .top) {
            // Outer container background
            RoundedRectangle(cornerRadius: largeContainerRadius)
                .fill(ADIBColors.Surface.blueOne)
                .frame(height: largeContainerHeight)

            VStack(spacing: 0) {
                // Inner card with heading + image
                ZStack(alignment: .topLeading) {
                    // Inner card background
                    RoundedRectangle(cornerRadius: largeInnerRadius)
                        .fill(ADIBColors.Segment.Mass.two)
                        .frame(height: largeInnerHeight)

                    // Heading — left side
                    Text(heading)
                        .adibTextStyle(ADIBTypography.h4.semibold, color: ADIBColors.Text.base)
                        .frame(width: largeHeadingWidth, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, largeHeadingLeading)
                        .padding(.top, largeHeadingTop)

                    // Product image — right side
                    HStack {
                        Spacer()
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: largeImageSize, height: largeImageSize)
                            .clipped()
                            .padding(.trailing, largeImageTrailing)
                            .padding(.top, largeImageTop)
                    }
                }
                .frame(height: largeInnerHeight)
                .clipShape(RoundedRectangle(cornerRadius: largeInnerRadius))

                // Call to action text — centered below inner card
                if let callToAction, !callToAction.isEmpty {
                    Text(callToAction)
                        .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: largeContainerHeight - largeInnerHeight)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: largeContainerHeight)
        .clipShape(RoundedRectangle(cornerRadius: largeContainerRadius))
    }

    // =========================================================================
    // MARK: - Small Layout
    // =========================================================================

    /// 60×60 image thumbnail + heading + description.
    private var smallLayout: some View {
        HStack(alignment: .center, spacing: smallContentGap) {
            // Image thumbnail
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: smallImageSize, height: smallImageSize)
                .clipShape(RoundedRectangle(cornerRadius: smallImageRadius))

            // Text content
            VStack(alignment: .leading, spacing: smallTextGap) {
                Text(heading)
                    .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                    .lineLimit(1)

                if let description, !description.isEmpty {
                    Text(description)
                        .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(smallPadding)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: smallContainerRadius)
                .fill(ADIBColors.Segment.Mass.two)
        )
        .clipShape(RoundedRectangle(cornerRadius: smallContainerRadius))
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Large Promotion") {
    ADIBPromotion(
        size: .large,
        image: Image(systemName: "creditcard.fill"),
        heading: "Promotional heading goes here in three lines",
        callToAction: "👏🏽 Text with a call to action",
        onTap: { print("Promotion tapped") }
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Small Promotion") {
    VStack(spacing: ADIBSizes.Spacing.medium) {
        ADIBPromotion(
            size: .small,
            image: Image(systemName: "cup.and.saucer.fill"),
            heading: "Promotional heading here",
            description: "Description here. Max two lines of content goes here.",
            onTap: { print("Promotion tapped") }
        )

        ADIBPromotion(
            size: .small,
            image: Image(systemName: "gift.fill"),
            heading: "Another promotion",
            description: "Short description.",
            onTap: { print("Promotion tapped") }
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
