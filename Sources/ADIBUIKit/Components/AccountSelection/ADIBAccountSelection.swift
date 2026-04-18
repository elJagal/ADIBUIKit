import SwiftUI

// MARK: - Account Selection Type

/// The display type for the account selection component.
public enum ADIBAccountSelectionType {
    /// Shows account info: logo, heading, balance, chevron-down.
    case `default`
    /// Shows a plus-circle icon with "Select an account" prompt.
    case emptyState
}

// MARK: - Account Selection Component

/// An account selection card from the ADIB design system.
///
/// Displays either a filled account card (with logo, account name,
/// balance, and a chevron-down to switch) or an empty state prompting
/// the user to select an account.
///
/// Supports optional error text below the card content.
///
/// ```swift
/// // Default — filled account
/// ADIBAccountSelection(
///     heading: "Current account \u{2022} 0711",
///     subtitle: "Balance: AED 230,000.10",
///     leadingImage: Image("adib-logo"),
///     onTap: { showAccountPicker = true }
/// )
///
/// // Empty state
/// ADIBAccountSelection(
///     type: .emptyState,
///     emptyStateText: "Select an account",
///     onTap: { showAccountPicker = true }
/// )
///
/// // With error
/// ADIBAccountSelection(
///     heading: "Current account \u{2022} 0711",
///     subtitle: "Balance: AED 230,000.10",
///     leadingImage: Image("adib-logo"),
///     errorText: "You have insufficient funds for this payment.",
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
    private let emptyStateIcon: Image?
    private let emptyStateText: String
    private let errorText: String?
    private let isDisabled: Bool
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let containerRadius: CGFloat = ADIBSizes.Radius.default            // 20
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = ADIBSizes.Spacing.medium            // 16
    private let contentGap: CGFloat = ADIBSizes.Spacing.small                  // 8
    private let emptyStateGap: CGFloat = 12
    private let iconSize: CGFloat = ADIBSizes.Spacing.large                    // 24
    private let errorGap: CGFloat = ADIBSizes.Spacing.small                    // 8

    // MARK: - Init

    /// Creates an account selection component.
    /// - Parameters:
    ///   - type: The display type (default `.default`).
    ///   - heading: The account name/title (e.g. "Current account \u{2022} 0711").
    ///   - subtitle: The balance or secondary text (e.g. "Balance: AED 230,000.10").
    ///   - leadingImage: The leading image/logo (e.g. ADIB logo or bank icon).
    ///   - showLeadingImage: Whether to show the leading image (default `true`).
    ///   - trailingIcon: The trailing icon (defaults to SF Symbol `chevron.down`).
    ///   - showTrailingIcon: Whether to show the trailing icon (default `true`).
    ///   - emptyStateIcon: The icon for empty state (defaults to SF Symbol `plus.circle.fill`).
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
            VStack(alignment: .leading, spacing: errorGap) {
                // Main content
                switch type {
                case .default:
                    defaultContent
                case .emptyState:
                    emptyStateContent
                }

                // Error text
                if let errorText, !errorText.isEmpty {
                    Text(errorText)
                        .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Semantic.Error.two)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: containerRadius)
                    .fill(ADIBColors.Surface.components)
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    // MARK: - Default Content

    private var defaultContent: some View {
        HStack(spacing: contentGap) {
            // Leading image (ADIB logo)
            if showLeadingImage, let leadingImage {
                leadingImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .clipShape(Circle())
            }

            // Text content
            VStack(alignment: .leading, spacing: 0) {
                // Heading row with trailing icon
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

                // Subtitle (balance)
                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                        .lineLimit(1)
                }
            }
        }
    }

    // MARK: - Empty State Content

    private var emptyStateContent: some View {
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

        ADIBAccountSelection(
            heading: "Savings account \u{2022} 0523",
            subtitle: "Balance: AED 15,420.75",
            leadingImage: Image(systemName: "building.columns.circle.fill"),
            onTap: { print("Select account") }
        )
    }
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

#Preview("With Error") {
    ADIBAccountSelection(
        heading: "Current account \u{2022} 0711",
        subtitle: "Balance: AED 230,000.10",
        leadingImage: Image(systemName: "building.columns.circle.fill"),
        errorText: "You have insufficient funds for this payment.",
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
