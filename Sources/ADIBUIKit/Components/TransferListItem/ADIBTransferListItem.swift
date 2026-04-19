import SwiftUI

// MARK: - Transfer List Item Component

/// A transfer list item from the ADIB design system.
///
/// Displays a leading icon (e.g. country flag), heading, amount with
/// a trailing chevron, and a bank info row with icon and label.
///
/// ```swift
/// ADIBTransferListItem(
///     leadingImage: Image("uae-flag"),
///     heading: "Mohammed Saleh",
///     amount: "AED5,000.00",
///     bankInfo: "ADIB UAE \u{2022} 1234",
///     bankIcon: Image(systemName: "building.columns"),
///     onTap: { navigateToDetail() }
/// )
/// ```
public struct ADIBTransferListItem: View {

    // MARK: - Properties

    private let leadingImage: Image
    private let heading: String
    private let amount: String
    private let bankInfo: String?
    private let bankIcon: Image?
    private let trailingIcon: Image?
    private let showDivider: Bool
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let iconSize: CGFloat = ADIBSizes.Spacing.large               // 24
    private let contentGap: CGFloat = ADIBSizes.Spacing.medium            // 16
    private let rowGap: CGFloat = ADIBSizes.Spacing.xsmall                // 4
    private let bankInfoGap: CGFloat = ADIBSizes.Spacing.xsmall           // 4
    private let bankIconSize: CGFloat = ADIBSizes.Spacing.medium          // 16
    private let chevronSize: CGFloat = ADIBSizes.Spacing.large            // 24
    private let dividerTopPadding: CGFloat = ADIBSizes.Spacing.medium     // 16

    // MARK: - Init

    /// Creates a transfer list item.
    /// - Parameters:
    ///   - leadingImage: The leading icon/flag image (24×24).
    ///   - heading: The heading text (e.g. beneficiary name).
    ///   - amount: The amount text (e.g. "AED5,000.00").
    ///   - bankInfo: Optional bank/account info string (e.g. "ADIB UAE • 1234").
    ///   - bankIcon: Optional icon next to the bank info.
    ///   - trailingIcon: Optional trailing icon. Defaults to chevron-right from assets.
    ///   - showDivider: Whether to show a bottom divider (default `true`).
    ///   - onTap: Optional tap action for the entire row.
    public init(
        leadingImage: Image,
        heading: String,
        amount: String,
        bankInfo: String? = nil,
        bankIcon: Image? = nil,
        trailingIcon: Image? = nil,
        showDivider: Bool = true,
        onTap: (() -> Void)? = nil
    ) {
        self.leadingImage = leadingImage
        self.heading = heading
        self.amount = amount
        self.bankInfo = bankInfo
        self.bankIcon = bankIcon
        self.trailingIcon = trailingIcon
        self.showDivider = showDivider
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        let content = rowContent

        if let onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }

    // MARK: - Row Content

    private var rowContent: some View {
        HStack(alignment: .top, spacing: contentGap) {
            // Leading icon/flag
            leadingImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: iconSize, height: iconSize)
                .clipShape(Circle())

            // Content + divider
            VStack(alignment: .leading, spacing: 0) {
                // Info block
                VStack(alignment: .leading, spacing: rowGap) {
                    // Heading + amount + chevron row
                    HStack(spacing: 0) {
                        Text(heading)
                            .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                            .lineLimit(1)

                        Spacer(minLength: ADIBSizes.Spacing.small)

                        Text(amount)
                            .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
                            .lineLimit(1)

                        // Trailing chevron
                        (trailingIcon ?? Image("chevron-right", bundle: .module))
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: chevronSize, height: chevronSize)
                            .foregroundStyle(ADIBColors.Text.subdued)
                    }

                    // Bank info row
                    if let bankInfo, !bankInfo.isEmpty {
                        HStack(spacing: bankInfoGap) {
                            if let bankIcon {
                                bankIcon
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: bankIconSize, height: bankIconSize)
                                    .foregroundStyle(ADIBColors.Text.subdued)
                            }

                            Text(bankInfo)
                                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
                                .lineLimit(1)
                        }
                    }
                }

                // Divider
                if showDivider {
                    Rectangle()
                        .fill(ADIBColors.border)
                        .frame(height: 1)
                        .padding(.top, dividerTopPadding)
                }
            }
        }
        .padding(.top, dividerTopPadding)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Transfer List Item") {
    VStack(spacing: 0) {
        ADIBTransferListItem(
            leadingImage: Image(systemName: "flag.fill"),
            heading: "Mohammed Saleh",
            amount: "AED5,000.00",
            bankInfo: "ADIB UAE \u{2022} 1234",
            bankIcon: Image(systemName: "building.columns"),
            onTap: { print("Tapped") }
        )

        ADIBTransferListItem(
            leadingImage: Image(systemName: "flag.fill"),
            heading: "Sara Ahmed",
            amount: "AED12,500.00",
            bankInfo: "ENBD \u{2022} 4521",
            bankIcon: Image(systemName: "building.columns"),
            onTap: { print("Tapped") }
        )

        ADIBTransferListItem(
            leadingImage: Image(systemName: "flag.fill"),
            heading: "Yousuf Abdulla",
            amount: "AED800.00",
            bankInfo: "ADIB UAE \u{2022} 7890",
            bankIcon: Image(systemName: "building.columns"),
            showDivider: false,
            onTap: { print("Tapped") }
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
