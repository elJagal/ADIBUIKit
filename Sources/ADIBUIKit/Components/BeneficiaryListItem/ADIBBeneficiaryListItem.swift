import SwiftUI

// MARK: - Beneficiary List Item Component

/// A beneficiary list item from the ADIB design system.
///
/// Displays a circular avatar, beneficiary name, full name,
/// bank info row (icon + label), and a trailing more-options button.
/// A bottom divider separates items in a list.
///
/// ```swift
/// ADIBBeneficiaryListItem(
///     image: Image("avatar"),
///     name: "Yousuf Abdulla",
///     fullName: "Yousuf Ahmed Abdullah",
///     bankInfo: "ADIB UAE \u{2022} 3262",
///     bankIcon: Image(systemName: "smartphone"),
///     onMoreTap: { showOptions() }
/// )
/// ```
public struct ADIBBeneficiaryListItem: View {

    // MARK: - Properties

    private let image: Image
    private let name: String
    private let fullName: String?
    private let bankInfo: String?
    private let bankIcon: Image?
    private let showDivider: Bool
    private let onTap: (() -> Void)?
    private let onMoreTap: (() -> Void)?

    // MARK: - Constants

    private let avatarSize: CGFloat = ADIBSizes.Spacing.large             // 24
    private let contentGap: CGFloat = ADIBSizes.Spacing.medium            // 16
    private let textBlockGap: CGFloat = ADIBSizes.Spacing.xsmall          // 4
    private let bankInfoGap: CGFloat = ADIBSizes.Spacing.xsmall           // 4
    private let bankIconSize: CGFloat = ADIBSizes.Spacing.medium          // 16
    private let moreIconSize: CGFloat = ADIBSizes.Spacing.large           // 24
    private let dividerTopPadding: CGFloat = ADIBSizes.Spacing.medium     // 16

    // MARK: - Init

    /// Creates a beneficiary list item.
    /// - Parameters:
    ///   - image: The circular avatar image.
    ///   - name: The beneficiary display name (semibold).
    ///   - fullName: The full name shown below the display name (optional).
    ///   - bankInfo: The bank/account info string (e.g. "ADIB UAE • 3262").
    ///   - bankIcon: The icon next to the bank info (e.g. smartphone icon).
    ///   - showDivider: Whether to show the bottom divider (default `true`).
    ///   - onTap: Optional tap action for the entire row.
    ///   - onMoreTap: Optional tap action for the trailing more button.
    public init(
        image: Image,
        name: String,
        fullName: String? = nil,
        bankInfo: String? = nil,
        bankIcon: Image? = nil,
        showDivider: Bool = true,
        onTap: (() -> Void)? = nil,
        onMoreTap: (() -> Void)? = nil
    ) {
        self.image = image
        self.name = name
        self.fullName = fullName
        self.bankInfo = bankInfo
        self.bankIcon = bankIcon
        self.showDivider = showDivider
        self.onTap = onTap
        self.onMoreTap = onMoreTap
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
            // Avatar
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: avatarSize, height: avatarSize)
                .clipShape(Circle())

            // Text content + divider
            VStack(alignment: .leading, spacing: dividerTopPadding) {
                // Info block
                VStack(alignment: .leading, spacing: textBlockGap) {
                    // Name row with more button
                    HStack(alignment: .top, spacing: contentGap) {
                        // Name + full name
                        VStack(alignment: .leading, spacing: 0) {
                            Text(name)
                                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)

                            if let fullName, !fullName.isEmpty {
                                Text(fullName)
                                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.subdued)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // More button
                        if let onMoreTap {
                            Button(action: onMoreTap) {
                                Image(systemName: "ellipsis")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: moreIconSize, height: moreIconSize)
                                    .foregroundStyle(ADIBColors.Text.subdued)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
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
                        }
                    }
                }

                // Divider
                if showDivider {
                    Rectangle()
                        .fill(ADIBColors.border)
                        .frame(height: 1)
                }
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Beneficiary List Item") {
    VStack(spacing: 0) {
        ADIBBeneficiaryListItem(
            image: Image(systemName: "person.crop.circle.fill"),
            name: "Yousuf Abdulla",
            fullName: "Yousuf Ahmed Abdullah",
            bankInfo: "ADIB UAE \u{2022} 3262",
            bankIcon: Image(systemName: "iphone"),
            onMoreTap: { print("More tapped") }
        )

        ADIBBeneficiaryListItem(
            image: Image(systemName: "person.crop.circle.fill"),
            name: "Mohammed Saleh",
            fullName: "Mohammed Ahmed Saleh",
            bankInfo: "ENBD \u{2022} 4521",
            bankIcon: Image(systemName: "iphone"),
            onMoreTap: { print("More tapped") }
        )

        ADIBBeneficiaryListItem(
            image: Image(systemName: "person.crop.circle.fill"),
            name: "Sara Ahmed",
            bankInfo: "ADIB UAE \u{2022} 7890",
            bankIcon: Image(systemName: "iphone"),
            showDivider: false,
            onMoreTap: { print("More tapped") }
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
