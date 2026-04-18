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
    private let showArrow: Bool
    private let onTap: (() -> Void)?

    // MARK: - Constants (Large)

    private let largeContainerHeight: CGFloat = 157
    private let largeContainerRadius: CGFloat = ADIBSizes.Radius.medium         // 16
    private let largeInnerHeight: CGFloat = 115                                 // 108 + 7 (extra bottom padding)
    private let largeInnerRadius: CGFloat = 10
    private let largeHeadingLeading: CGFloat = 20
    private let largeHeadingTop: CGFloat = 20
    private let largeHeadingWidth: CGFloat = 188
    private let largeImageWidth: CGFloat = 127
    private let largeImageLeading: CGFloat = 208
    private let largeCTATop: CGFloat = 127                                      // 120 + 7

    // MARK: - Constants (Small)

    private let smallContainerRadius: CGFloat = ADIBSizes.Radius.medium         // 16
    private let smallPadding: CGFloat = ADIBSizes.Spacing.small                 // 8
    private let smallImageSize: CGFloat = 60
    private let smallImageRadius: CGFloat = ADIBSizes.Radius.small              // 12
    private let smallContentGap: CGFloat = 12
    private let smallTextGap: CGFloat = ADIBSizes.Spacing.xxsmall              // 2
    private let smallArrowSize: CGFloat = ADIBSizes.Spacing.large              // 24

    // MARK: - Init

    /// Creates a promotion component.
    /// - Parameters:
    ///   - size: The promotion size variant (default `.large`).
    ///   - image: The promotional image (product image for large, thumbnail for small).
    ///   - heading: The heading text.
    ///   - description: The description text (used in `.small` variant).
    ///   - callToAction: The call-to-action text (used in `.large` variant).
    ///   - showArrow: Whether to show a trailing arrow (used in `.small` variant, default `false`).
    ///   - onTap: Optional tap action.
    public init(
        size: ADIBPromotionSize = .large,
        image: Image,
        heading: String,
        description: String? = nil,
        callToAction: String? = nil,
        showArrow: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.size = size
        self.image = image
        self.heading = heading
        self.description = description
        self.callToAction = callToAction
        self.showArrow = showArrow
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

    /// Inner card (heading + image clipped), CTA text in bottom strip.
    private var largeLayout: some View {
        ZStack(alignment: .topLeading) {
            // Outer container background
            RoundedRectangle(cornerRadius: largeContainerRadius)
                .fill(ADIBColors.Surface.blueOne)

            // Inner card — heading left, image right, overflow clipped
            ZStack(alignment: .topLeading) {
                // Inner card background
                RoundedRectangle(cornerRadius: largeInnerRadius)
                    .fill(ADIBColors.Segment.Mass.two)

                // Heading — left side
                Text(heading)
                    .adibTextStyle(ADIBTypography.h4.semibold, color: ADIBColors.Text.base)
                    .frame(width: largeHeadingWidth, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, largeHeadingLeading)
                    .padding(.top, largeHeadingTop)

                // Product image — right side, clipped to inner card
                GeometryReader { geo in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: largeImageWidth, height: largeInnerHeight)
                        .clipped()
                        .position(
                            x: largeImageLeading + largeImageWidth / 2,
                            y: largeInnerHeight / 2
                        )
                }
            }
            .frame(height: largeInnerHeight)
            .clipShape(RoundedRectangle(cornerRadius: largeInnerRadius))

            // Call to action text — centred in bottom strip
            if let callToAction, !callToAction.isEmpty {
                Text(callToAction)
                    .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, largeCTATop)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: largeContainerHeight)
        .clipShape(RoundedRectangle(cornerRadius: largeContainerRadius))
    }

    // =========================================================================
    // MARK: - Small Layout
    // =========================================================================

    /// 60×60 image/icon box + heading + description + optional arrow.
    private var smallLayout: some View {
        HStack(alignment: .center, spacing: smallContentGap) {
            // Icon/Image box
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: smallImageSize, height: smallImageSize)
                .background(
                    RoundedRectangle(cornerRadius: smallImageRadius)
                        .fill(ADIBColors.Surface.blueOne)
                )
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

            // Trailing arrow
            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(ADIBColors.Text.subdued)
                    .frame(width: smallArrowSize, height: smallArrowSize)
            }
        }
        .padding(smallPadding)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: smallContainerRadius)
                .fill(ADIBColors.Segment.surface)
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
            image: Image(systemName: "dollarsign.circle.fill"),
            heading: "Get Finance",
            description: "Kick start your financial goals with our financing solutions",
            showArrow: true,
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
