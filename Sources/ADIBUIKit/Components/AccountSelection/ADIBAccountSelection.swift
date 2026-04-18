import SwiftUI

// MARK: - Account Selection Type

/// The display type for the account selection component.
public enum ADIBAccountSelectionType {
    /// Default filled state with ADIB logo, heading, subtitle, chevron-down.
    case `default`

    /// Send money variant — heading + subtitle + chevron, flag + editable amount.
    case sendMoney

    /// Request money variant — heading + subtitle + chevron, separator, "Amount I need:" + amount.
    case requestMoney

    /// To variant — heading only (e.g. "To: Mohammed Ahmed • 1234"), no subtitle/chevron/amount.
    case to

    /// Empty state — plus-circle icon + "Select an account".
    case emptyState
}

// MARK: - Account Selection Component

/// An account selection / big input card from the ADIB design system.
///
/// Supports five layout types covering account pickers and money transfer inputs.
///
/// ```swift
/// // Default — filled account selector
/// ADIBAccountSelection(
///     heading: "Current account \u{2022} 0711",
///     subtitle: "Balance: AED 230,000.10",
///     leadingImage: Image("adib-logo"),
///     onTap: { showAccountPicker = true }
/// )
///
/// // Send Money — with flag and amount
/// ADIBAccountSelection(
///     type: .sendMoney,
///     heading: "From: Current account \u{2022} 0711",
///     subtitle: "Balance: AED 230,000.10",
///     amountText: "0",
///     flagImage: Image("uae-flag"),
///     onTap: { showAccountPicker = true }
/// )
///
/// // Request Money — with separator and amount
/// ADIBAccountSelection(
///     type: .requestMoney,
///     heading: "To: Current account \u{2022} 0711",
///     subtitle: "Balance: AED 230,000.10",
///     amountText: "0",
///     onTap: { showAccountPicker = true }
/// )
///
/// // To — heading only
/// ADIBAccountSelection(
///     type: .to,
///     heading: "To: Mohammed Ahmed \u{2022} 1234",
///     onTap: { showDetails = true }
/// )
///
/// // Empty state
/// ADIBAccountSelection(
///     type: .emptyState,
///     onTap: { showAccountPicker = true }
/// )
/// ```
public struct ADIBAccountSelection: View {

    // MARK: - Properties

    private let type: ADIBAccountSelectionType
    private let heading: String?
    private let subtitle: String?
    private let leadingImage: Image?
    private let showLeadingImage: Bool
    private let trailingIcon: Image?
    private let showTrailingIcon: Bool
    private let amountText: String?
    private let amountLabel: String?
    private let flagImage: Image?
    private let showFlag: Bool
    private let emptyStateIcon: Image?
    private let emptyStateText: String
    private let errorText: String?
    private let isDisabled: Bool
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let containerRadius: CGFloat = ADIBSizes.Radius.default            // 20
    private let horizontalPadding: CGFloat = 20
    private let defaultVerticalPadding: CGFloat = ADIBSizes.Spacing.medium     // 16
    private let contentGap: CGFloat = ADIBSizes.Spacing.small                  // 8
    private let emptyStateGap: CGFloat = 12
    private let iconSize: CGFloat = ADIBSizes.Spacing.large                    // 24
    private let flagSize: CGFloat = 18
    private let flagRadius: CGFloat = 12
    private let amountLabelGap: CGFloat = ADIBSizes.Spacing.xsmall            // 4
    private let separatorGap: CGFloat = ADIBSizes.Spacing.medium              // 16
    private let emptyStateHeight: CGFloat = 72

    // MARK: - Init

    /// Creates an account selection component.
    /// - Parameters:
    ///   - type: The display type (default `.default`).
    ///   - heading: The account name/title (e.g. "Current account \u{2022} 0711").
    ///   - subtitle: The balance text (e.g. "Balance: AED 230,000.10").
    ///   - leadingImage: The leading image/logo (e.g. ADIB logo). Used in `.default` type.
    ///   - showLeadingImage: Whether to show the leading image (default `true`).
    ///   - trailingIcon: The trailing icon (defaults to chevron.down). Used in `.default`, `.sendMoney`, `.requestMoney`.
    ///   - showTrailingIcon: Whether to show the trailing icon (default `true`).
    ///   - amountText: The amount value string (e.g. "0"). Used in `.sendMoney`, `.requestMoney`.
    ///   - amountLabel: The label above the amount (default "Amount I need:"). Used in `.requestMoney`.
    ///   - flagImage: The flag/country image. Used in `.sendMoney`.
    ///   - showFlag: Whether to show the flag image (default `true`).
    ///   - emptyStateIcon: The icon for empty state (defaults to plus.circle.fill).
    ///   - emptyStateText: The text for empty state (default "Select an account").
    ///   - errorText: Optional error text below the card.
    ///   - isDisabled: Whether the component is disabled (default `false`).
    ///   - onTap: The action when the card is tapped.
    public init(
        type: ADIBAccountSelectionType = .default,
        heading: String? = nil,
        subtitle: String? = nil,
        leadingImage: Image? = nil,
        showLeadingImage: Bool = true,
        trailingIcon: Image? = nil,
        showTrailingIcon: Bool = true,
        amountText: String? = nil,
        amountLabel: String? = nil,
        flagImage: Image? = nil,
        showFlag: Bool = true,
        emptyStateIcon: Image? = nil,
        emptyStateText: String = "Select an account",
        errorText: String? = nil,
        isDisabled: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.type = type
        self.heading = heading
        self.subtitle = subtitle
        self.leadingImage = leadingImage
        self.showLeadingImage = showLeadingImage
        self.trailingIcon = trailingIcon
        self.showTrailingIcon = showTrailingIcon
        self.amountText = amountText
        self.amountLabel = amountLabel
        self.flagImage = flagImage
        self.showFlag = showFlag
        self.emptyStateIcon = emptyStateIcon
        self.emptyStateText = emptyStateText
        self.errorText = errorText
        self.isDisabled = isDisabled
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button {
            onTap?()
        } label: {
            cardContent
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    // MARK: - Card Content

    @ViewBuilder
    private var cardContent: some View {
        switch type {
        case .default:
            defaultCard
        case .sendMoney:
            sendMoneyCard
        case .requestMoney:
            requestMoneyCard
        case .to:
            toCard
        case .emptyState:
            emptyStateCard
        }
    }

    // =========================================================================
    // MARK: - Default Variant
    // =========================================================================

    /// ADIB logo + heading + subtitle + chevron-down
    private var defaultCard: some View {
        VStack(alignment: .leading, spacing: contentGap) {
            HStack(spacing: contentGap) {
                // Leading image (ADIB logo)
                if showLeadingImage, let leadingImage {
                    leadingImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize)
                        .clipShape(Circle())
                }

                // Text + chevron
                VStack(alignment: .leading, spacing: 0) {
                    headingRow
                    subtitleText
                }
            }

            errorView
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, defaultVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(containerBackground)
    }

    // =========================================================================
    // MARK: - Send Money Variant
    // =========================================================================

    /// Heading + subtitle + chevron, flag + amount
    private var sendMoneyCard: some View {
        VStack(alignment: .leading, spacing: contentGap) {
            // Account info
            VStack(alignment: .leading, spacing: 0) {
                headingRow
                subtitleText
            }

            // Flag + Amount
            HStack(spacing: ADIBSizes.Spacing.xxsmall) {
                if showFlag, let flagImage {
                    flagImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: flagSize, height: flagSize)
                        .clipShape(RoundedRectangle(cornerRadius: flagRadius))
                }
                amountView
            }

            errorView
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, defaultVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(containerBackground)
    }

    // =========================================================================
    // MARK: - Request Money Variant
    // =========================================================================

    /// Heading + subtitle + chevron, separator, amount label + amount
    private var requestMoneyCard: some View {
        VStack(alignment: .leading, spacing: contentGap) {
            // Account info
            VStack(alignment: .leading, spacing: 0) {
                headingRow
                subtitleText
            }

            // Separator line
            Rectangle()
                .fill(ADIBColors.border)
                .frame(height: 1)
                .frame(maxWidth: .infinity)

            // Amount label + amount
            VStack(alignment: .leading, spacing: amountLabelGap) {
                Text(amountLabel ?? "Amount I need:")
                    .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)

                amountView
            }

            errorView
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, 12)
        .padding(.bottom, ADIBSizes.Spacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(containerBackground)
    }

    // =========================================================================
    // MARK: - To Variant
    // =========================================================================

    /// Heading only — no subtitle, no chevron, no amount
    private var toCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let heading {
                Text(heading)
                    .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, defaultVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(containerBackground)
    }

    // =========================================================================
    // MARK: - Empty State Variant
    // =========================================================================

    /// Plus-circle icon + "Select an account"
    private var emptyStateCard: some View {
        HStack(spacing: emptyStateGap) {
            (emptyStateIcon ?? Image(systemName: "plus.circle.fill"))
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(ADIBColors.interaction)

            Text(emptyStateText)
                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: emptyStateHeight)
        .padding(.horizontal, horizontalPadding)
        .background(containerBackground)
    }

    // =========================================================================
    // MARK: - Shared Sub-Views
    // =========================================================================

    /// Heading text + trailing chevron icon in an HStack.
    private var headingRow: some View {
        HStack {
            if let heading {
                Text(heading)
                    .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            if showTrailingIcon {
                (trailingIcon ?? Image(systemName: "chevron.down"))
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(ADIBColors.Text.base)
            }
        }
    }

    /// Subtitle text (balance).
    @ViewBuilder
    private var subtitleText: some View {
        if let subtitle, !subtitle.isEmpty {
            Text(subtitle)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                .lineLimit(1)
        }
    }

    /// Amount display — "AED" prefix + amount value in H3 semibold.
    @ViewBuilder
    private var amountView: some View {
        HStack(spacing: ADIBSizes.Spacing.xxsmall) {
            Text("AED")
                .adibTextStyle(ADIBTypography.h3.semibold, color: ADIBColors.Text.base)
            Text(amountText ?? "0")
                .adibTextStyle(ADIBTypography.h3.semibold, color: ADIBColors.Text.base)
        }
    }

    /// Error text below content.
    @ViewBuilder
    private var errorView: some View {
        if let errorText, !errorText.isEmpty {
            Text(errorText)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Semantic.Error.two)
        }
    }

    /// Shared container background.
    private var containerBackground: some View {
        RoundedRectangle(cornerRadius: containerRadius)
            .fill(ADIBColors.Surface.components)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Default — Filled") {
    VStack(spacing: ADIBSizes.Spacing.medium) {
        ADIBAccountSelection(
            heading: "Current account \u{2022} 0711",
            subtitle: "Balance: AED 230,000.10",
            leadingImage: Image(systemName: "building.columns.circle.fill"),
            onTap: { print("Select account") }
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Send Money") {
    ADIBAccountSelection(
        type: .sendMoney,
        heading: "From: Current account \u{2022} 0711",
        subtitle: "Balance: AED 230,000.10",
        amountText: "0",
        flagImage: Image(systemName: "flag.circle.fill"),
        onTap: { print("Select account") }
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Send Money — Error") {
    ADIBAccountSelection(
        type: .sendMoney,
        heading: "From: Current account \u{2022} 0711",
        subtitle: "Balance: AED 230,000.10",
        amountText: "0",
        flagImage: Image(systemName: "flag.circle.fill"),
        errorText: "You have insufficient funds for this payment.",
        onTap: { print("Select account") }
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Request Money") {
    ADIBAccountSelection(
        type: .requestMoney,
        heading: "To: Current account \u{2022} 0711",
        subtitle: "Balance: AED 230,000.10",
        amountText: "0",
        onTap: { print("Select account") }
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("To") {
    ADIBAccountSelection(
        type: .to,
        heading: "To: Mohammed Ahmed \u{2022} 1234",
        showTrailingIcon: false,
        onTap: { print("View details") }
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Empty State") {
    ADIBAccountSelection(
        type: .emptyState,
        onTap: { print("Select account") }
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Disabled") {
    ADIBAccountSelection(
        heading: "Current account \u{2022} 0711",
        subtitle: "Balance: AED 230,000.10",
        leadingImage: Image(systemName: "building.columns.circle.fill"),
        isDisabled: true
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
