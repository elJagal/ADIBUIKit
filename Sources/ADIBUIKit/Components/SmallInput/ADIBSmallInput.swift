import SwiftUI

// MARK: - Small Input Component

/// A compact read-only input card from the ADIB design system.
///
/// Displays a heading label and an amount row with an optional
/// flag/icon image. Typically used in transfer confirmation screens
/// to show the recipient and amount.
///
/// ```swift
/// // Basic usage
/// ADIBSmallInput(
///     heading: "To: Mohammed Saleh \u{2022} 1234",
///     amount: "AED 20,000.00",
///     flagImage: Image("uae-flag")
/// )
///
/// // Without flag
/// ADIBSmallInput(
///     heading: "To: Mohammed Saleh \u{2022} 1234",
///     amount: "AED 20,000.00"
/// )
///
/// // Disabled
/// ADIBSmallInput(
///     heading: "To: Mohammed Saleh \u{2022} 1234",
///     amount: "AED 20,000.00",
///     flagImage: Image("uae-flag"),
///     isDisabled: true
/// )
/// ```
public struct ADIBSmallInput: View {

    // MARK: - Properties

    private let heading: String
    private let amount: String
    private let flagImage: Image?
    private let showFlag: Bool
    private let isDisabled: Bool
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let containerRadius: CGFloat = ADIBSizes.Radius.default        // 20
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = ADIBSizes.Spacing.medium        // 16
    private let contentGap: CGFloat = ADIBSizes.Spacing.xsmall             // 4
    private let amountRowGap: CGFloat = ADIBSizes.Spacing.small            // 8
    private let flagSize: CGFloat = 18
    private let flagRadius: CGFloat = 12

    // MARK: - Init

    /// Creates a small input card.
    /// - Parameters:
    ///   - heading: The heading label (e.g. "To: Mohammed Saleh \u{2022} 1234").
    ///   - amount: The amount text (e.g. "AED 20,000.00").
    ///   - flagImage: Optional flag/country image (18×18, rounded).
    ///   - showFlag: Whether to show the flag image (default `true`).
    ///   - isDisabled: Whether the component is disabled (default `false`).
    ///   - onTap: Optional tap action.
    public init(
        heading: String,
        amount: String,
        flagImage: Image? = nil,
        showFlag: Bool = true,
        isDisabled: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.heading = heading
        self.amount = amount
        self.flagImage = flagImage
        self.showFlag = showFlag
        self.isDisabled = isDisabled
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        let content = cardContent

        if let onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.2 : 1.0)
        } else {
            content
        }
    }

    // MARK: - Card Content

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: contentGap) {
            // Heading
            Text(heading)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                .lineLimit(1)

            // Amount text
            Text(amount)
                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: containerRadius)
                .fill(ADIBColors.Segment.Mass.two)
        )
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Small Input") {
    VStack(spacing: ADIBSizes.Spacing.medium) {
        ADIBSmallInput(
            heading: "To: Mohammed Saleh \u{2022} 1234",
            amount: "AED 20,000.00",
            flagImage: Image(systemName: "globe.europe.africa.fill")
        )

        ADIBSmallInput(
            heading: "To: Mohammed Saleh \u{2022} 1234",
            amount: "AED 20,000.00"
        )

        ADIBSmallInput(
            heading: "To: Mohammed Saleh \u{2022} 1234",
            amount: "AED 20,000.00",
            flagImage: Image(systemName: "globe.europe.africa.fill"),
            isDisabled: true
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
