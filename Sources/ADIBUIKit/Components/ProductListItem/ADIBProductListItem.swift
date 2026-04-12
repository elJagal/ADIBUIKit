import SwiftUI

/// The leading icon style for a product list item.
public enum ADIBProductIconStyle {
    /// An icon rendered on a colored background (e.g. accounts, savings, BNPL).
    /// Uses `ADIBColors.Segment.surface` as background.
    /// Optionally pass a custom icon color and background color.
    case iconOnBackground(Image, iconColor: Color? = nil, backgroundColor: Color? = nil)

    /// A full image thumbnail (e.g. card images like Emirates, Smiles, Visa).
    case image(Image)

    /// A logo/image inside a bordered container (e.g. other bank logos).
    case logoWithBorder(Image)
}

/// A product list item from the ADIB design system.
///
/// Displays a product with a leading icon/image, title, optional subtitle,
/// amount with currency symbol, and an optional trailing more button.
///
/// Three icon styles are supported:
/// - `.iconOnBackground`: Icon on a light blue surface (accounts, savings)
/// - `.image`: Full card/product image (credit cards)
/// - `.logoWithBorder`: Logo inside a bordered box (external banks)
///
/// ```swift
/// ADIBProductListItem(
///     iconStyle: .iconOnBackground(Image("cash-filled")),
///     title: "Current Account • 9876",
///     amount: "20,124.00",
///     currencySymbol: "D"
/// )
/// ```
public struct ADIBProductListItem: View {

    // MARK: - Properties

    private let iconStyle: ADIBProductIconStyle
    private let title: String
    private let subtitle: String?
    private let amount: String
    private let currencySymbol: String
    private let onMoreTap: (() -> Void)?

    // MARK: - Constants

    private let iconBoxSize: CGFloat = 48
    private let iconSize: CGFloat = ADIBSizes.Spacing.large            // 24
    private let iconBoxRadius: CGFloat = ADIBSizes.Radius.small        // 12
    private let iconBoxPadding: CGFloat = ADIBSizes.Radius.small       // 12
    private let contentSpacing: CGFloat = ADIBSizes.Spacing.medium     // 16
    private let moreIconSize: CGFloat = ADIBSizes.Spacing.large        // 24
    private let moreButtonPadding: CGFloat = ADIBSizes.Spacing.small   // 8
    private let subtitleSpacing: CGFloat = ADIBSizes.Spacing.xsmall    // 4

    // MARK: - Init

    /// Creates a product list item.
    /// - Parameters:
    ///   - iconStyle: The leading icon display style.
    ///   - title: The product name/description (e.g. "Current Account • 9876").
    ///   - subtitle: An optional secondary line (e.g. card holder name).
    ///   - amount: The balance or amount string (e.g. "20,124.00").
    ///   - currencySymbol: The currency symbol to display (e.g. "D", "$", "€", "£").
    ///   - onMoreTap: An optional action for the trailing more (•••) button.
    public init(
        iconStyle: ADIBProductIconStyle,
        title: String,
        subtitle: String? = nil,
        amount: String,
        currencySymbol: String = "AED ",
        onMoreTap: (() -> Void)? = {}
    ) {
        self.iconStyle = iconStyle
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.currencySymbol = currencySymbol
        self.onMoreTap = onMoreTap
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .center, spacing: contentSpacing) {
            // Leading icon
            leadingIcon

            // Text content
            VStack(alignment: .leading, spacing: subtitleSpacing) {
                Text(title)
                    .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
                    .lineLimit(1)

                if let subtitle {
                    Text(subtitle)
                        .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                        .lineLimit(1)
                }

                amountView
            }

            Spacer(minLength: 0)

            // Trailing more button
            if let onMoreTap {
                Button(action: onMoreTap) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(ADIBColors.interaction)
                        .frame(width: moreIconSize, height: moreIconSize)
                        .padding(moreButtonPadding)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Amount View

    private var amountView: some View {
        HStack(spacing: 0) {
            Text(currencySymbol)
                .adibTextStyle(ADIBTypography.h4.semibold, color: ADIBColors.Text.base)

            Text(amount)
                .adibTextStyle(ADIBTypography.h4.semibold, color: ADIBColors.Text.base)
        }
    }

    // MARK: - Leading Icon

    @ViewBuilder
    private var leadingIcon: some View {
        switch iconStyle {
        case .iconOnBackground(let icon, let iconColor, let backgroundColor):
            icon
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(iconColor ?? ADIBColors.Segment.accent)
                .padding(iconBoxPadding)
                .background(
                    RoundedRectangle(cornerRadius: iconBoxRadius)
                        .fill(backgroundColor ?? ADIBColors.Segment.surface)
                )

        case .image(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: iconBoxSize, height: iconBoxSize)
                .clipShape(RoundedRectangle(cornerRadius: iconBoxRadius))

        case .logoWithBorder(let logo):
            logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .padding(iconBoxPadding)
                .background(
                    RoundedRectangle(cornerRadius: iconBoxRadius)
                        .stroke(ADIBColors.border, lineWidth: 0.5)
                )
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Product List Items") {
    ScrollView {
        VStack(spacing: ADIBSizes.Spacing.large) {

            // Current Account
            ADIBProductListItem(
                iconStyle: .iconOnBackground(Image(systemName: "banknote.fill")),
                title: "Current Account • 9876",
                amount: "20,124.00",
                currencySymbol: "D"
            )

            // USD Savings
            ADIBProductListItem(
                iconStyle: .iconOnBackground(Image(systemName: "dollarsign.circle.fill")),
                title: "Savings Account • 1234",
                amount: "20,124.00",
                currencySymbol: "$"
            )

            // EUR Savings
            ADIBProductListItem(
                iconStyle: .iconOnBackground(Image(systemName: "eurosign.circle.fill")),
                title: "Savings Account • 1234",
                amount: "20,124.00",
                currencySymbol: "€"
            )

            // GBP Savings
            ADIBProductListItem(
                iconStyle: .iconOnBackground(Image(systemName: "sterlingsign.circle.fill")),
                title: "Savings Account • 1234",
                amount: "20,124.00",
                currencySymbol: "£"
            )

            // Other Bank
            ADIBProductListItem(
                iconStyle: .logoWithBorder(Image(systemName: "building.2.fill")),
                title: "Account name • 1234",
                amount: "20,124.00",
                currencySymbol: "D"
            )

            // Card
            ADIBProductListItem(
                iconStyle: .image(Image(systemName: "creditcard.fill")),
                title: "Emirates Skywards • 9876",
                amount: "100,000.00",
                currencySymbol: "D"
            )

            // Card Supplementary (with subtitle)
            ADIBProductListItem(
                iconStyle: .image(Image(systemName: "creditcard.fill")),
                title: "Smiles • 9876",
                subtitle: "Mohamad Ahmed",
                amount: "8,000.00",
                currencySymbol: "D"
            )

            // Card Debit
            ADIBProductListItem(
                iconStyle: .image(Image(systemName: "creditcard.fill")),
                title: "Visa Debit • 9876",
                amount: "340,613.32",
                currencySymbol: "D"
            )

            // BNPL
            ADIBProductListItem(
                iconStyle: .iconOnBackground(Image(systemName: "tag.fill")),
                title: "Available limit",
                amount: "50,000.00",
                currencySymbol: "D",
                onMoreTap: nil
            )

            // Smart Sukuk
            ADIBProductListItem(
                iconStyle: .iconOnBackground(Image(systemName: "chart.bar.fill")),
                title: "Smart Sukuk",
                amount: "200,124.00",
                currencySymbol: "D"
            )

            // Wealth
            ADIBProductListItem(
                iconStyle: .iconOnBackground(Image(systemName: "leaf.fill")),
                title: "Al baraka Sukuk LT...",
                amount: "209,435.34",
                currencySymbol: "D"
            )
        }
        .adibScreenPadding()
        .padding(.vertical, ADIBSizes.Spacing.medium)
    }
    .background(ADIBColors.background)
}
#endif
