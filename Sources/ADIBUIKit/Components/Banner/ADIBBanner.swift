import SwiftUI

// MARK: - Banner Style

/// The visual style for the banner (info, success, error, warning).
public enum ADIBBannerStyle {
    case info, success, error, warning

    /// Background color for the banner body.
    var backgroundColor: Color {
        switch self {
        case .info:    return ADIBColors.Banners.Info.background
        case .success: return ADIBColors.Banners.Success.background
        case .error:   return ADIBColors.Banners.Error.background
        case .warning: return ADIBColors.Banners.Warning.background
        }
    }

    /// Background color for the button bar.
    var buttonsBackground: Color {
        switch self {
        case .info:    return ADIBColors.Banners.Info.buttons
        case .success: return ADIBColors.Banners.Success.buttons
        case .error:   return ADIBColors.Banners.Error.buttons
        case .warning: return ADIBColors.Banners.Warning.buttons
        }
    }

    /// Icon tint color for the banner style.
    var iconColor: Color {
        switch self {
        case .info:    return ADIBColors.Semantic.Info.two
        case .success: return ADIBColors.Semantic.Success.two
        case .error:   return ADIBColors.Semantic.Error.two
        case .warning: return ADIBColors.Semantic.Warning.two
        }
    }
}

// MARK: - Banner Size

/// The size variant for the banner.
public enum ADIBBannerSize {
    /// Icon + title + description + optional button bar.
    case withButtons
    /// Icon + title + description (no buttons).
    case withHeading
    /// Icon + description only (no title, no buttons).
    case noHeading
}

// MARK: - Banner Component

/// A banner component from the ADIB design system.
///
/// Three size variants matching Figma:
///
/// ```swift
/// // With buttons
/// ADIBBanner(
///     size: .withButtons,
///     icon: Image("info"),
///     title: "Headline here",
///     description: "You can add no more than three lines of content.",
///     style: .info,
///     primaryButtonTitle: "Continue",
///     secondaryButtonTitle: "Get help",
///     onPrimaryButton: { },
///     onSecondaryButton: { }
/// )
///
/// // With heading (no buttons)
/// ADIBBanner(
///     size: .withHeading,
///     icon: Image("info"),
///     title: "Headline here",
///     description: "You can add no more than three lines of content.",
///     style: .success
/// )
///
/// // No heading (description only)
/// ADIBBanner(
///     size: .noHeading,
///     icon: Image("info"),
///     description: "You can add no more than three lines of content.",
///     style: .warning
/// )
/// ```
public struct ADIBBanner: View {

    // MARK: - Properties

    private let size: ADIBBannerSize
    private let icon: Image
    private let title: String?
    private let description: String
    private let style: ADIBBannerStyle
    private let primaryButtonTitle: String?
    private let secondaryButtonTitle: String?
    private let onPrimaryButton: (() -> Void)?
    private let onSecondaryButton: (() -> Void)?
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let containerRadius: CGFloat = ADIBSizes.Radius.small              // 12
    private let iconSize: CGFloat = ADIBSizes.Spacing.large                    // 24
    private let iconTextGap: CGFloat = 12
    private let contentTopPadding: CGFloat = ADIBSizes.Spacing.medium          // 16
    private let noHeadingPadding: CGFloat = 12
    private let contentBottomGap: CGFloat = ADIBSizes.Spacing.medium           // 16
    private let buttonBarHeight: CGFloat = 48
    private let buttonDividerColor: Color = Color.black.opacity(0.06)

    // MARK: - Init

    /// Creates a banner component.
    /// - Parameters:
    ///   - size: The banner size variant (default `.withHeading`).
    ///   - icon: The leading icon image (24×24).
    ///   - title: The bold title text (used in `.withButtons` and `.withHeading`).
    ///   - description: The description text.
    ///   - style: The banner visual style (default `.info`).
    ///   - primaryButtonTitle: The primary (right) button title. Used in `.withButtons`.
    ///   - secondaryButtonTitle: The secondary (left) button title. Used in `.withButtons`.
    ///   - onPrimaryButton: Action for the primary button.
    ///   - onSecondaryButton: Action for the secondary button.
    ///   - onTap: Optional tap action for the entire banner (non-button variants).
    public init(
        size: ADIBBannerSize = .withHeading,
        icon: Image,
        title: String? = nil,
        description: String,
        style: ADIBBannerStyle = .info,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil,
        onPrimaryButton: (() -> Void)? = nil,
        onSecondaryButton: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.size = size
        self.icon = icon
        self.title = title
        self.description = description
        self.style = style
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.onPrimaryButton = onPrimaryButton
        self.onSecondaryButton = onSecondaryButton
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if let onTap, size != .withButtons {
                Button(action: onTap) { bannerContent }
                    .buttonStyle(.plain)
            } else {
                bannerContent
            }
        }
    }

    @ViewBuilder
    private var bannerContent: some View {
        switch size {
        case .withButtons:
            withButtonsLayout
        case .withHeading:
            withHeadingLayout
        case .noHeading:
            noHeadingLayout
        }
    }

    // =========================================================================
    // MARK: - With Buttons Layout
    // =========================================================================

    /// Icon + title + description, then a full-width button bar
    private var withButtonsLayout: some View {
        VStack(spacing: contentBottomGap) {
            // Content area
            VStack(alignment: .leading, spacing: 0) {
                // Icon + Title row
                if let title, !title.isEmpty {
                    HStack(alignment: .top, spacing: iconTextGap) {
                        iconView
                        Text(title)
                            .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // Description — indented to align with title text
                Text(description)
                    .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, iconSize + iconTextGap)
            }
            .padding(.horizontal, contentTopPadding)

            // Button bar
            buttonBar
        }
        .padding(.top, contentTopPadding)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: containerRadius)
                .fill(style.backgroundColor)
        )
        .clipShape(RoundedRectangle(cornerRadius: containerRadius))
    }

    // =========================================================================
    // MARK: - With Heading Layout
    // =========================================================================

    /// Icon + title + description, no buttons
    private var withHeadingLayout: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Icon + Title row
            if let title, !title.isEmpty {
                HStack(alignment: .top, spacing: iconTextGap) {
                    iconView
                    Text(title)
                        .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // Description — indented to align with title
            Text(description)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, iconSize + iconTextGap)
        }
        .padding(contentTopPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: containerRadius)
                .fill(style.backgroundColor)
        )
        .clipShape(RoundedRectangle(cornerRadius: containerRadius))
    }

    // =========================================================================
    // MARK: - No Heading Layout
    // =========================================================================

    /// Icon + description only.
    /// Single-line → centre-aligned; multi-line → top-aligned.
    private var noHeadingLayout: some View {
        NoHeadingBannerLayout(
            icon: iconView,
            description: description,
            style: style,
            iconTextGap: iconTextGap,
            padding: noHeadingPadding,
            cornerRadius: containerRadius
        )
    }

    // =========================================================================
    // MARK: - Shared Sub-Views
    // =========================================================================

    /// The 24×24 icon view, tinted with the style's semantic color.
    private var iconView: some View {
        icon
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconSize, height: iconSize)
            .foregroundStyle(style.iconColor)
    }

    /// The button bar with 1 or 2 CTAs.
    private var buttonBar: some View {
        HStack(spacing: 0) {
            // Secondary button (left)
            if let secondaryButtonTitle, !secondaryButtonTitle.isEmpty {
                Button {
                    onSecondaryButton?()
                } label: {
                    Text(secondaryButtonTitle)
                        .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonBarHeight)
                }
                .buttonStyle(.plain)

                // Divider between buttons
                Rectangle()
                    .fill(buttonDividerColor)
                    .frame(width: 1, height: buttonBarHeight)
            }

            // Primary button (right)
            if let primaryButtonTitle, !primaryButtonTitle.isEmpty {
                Button {
                    onPrimaryButton?()
                } label: {
                    Text(primaryButtonTitle)
                        .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonBarHeight)
                }
                .buttonStyle(.plain)
            }
        }
        .background(style.buttonsBackground)
    }
}

// MARK: - No Heading Layout (adaptive alignment)

/// Internal helper that measures text height and switches between
/// `.center` (single line) and `.top` (multi-line) alignment.
private struct NoHeadingBannerLayout<Icon: View>: View {

    let icon: Icon
    let description: String
    let style: ADIBBannerStyle
    let iconTextGap: CGFloat
    let padding: CGFloat
    let cornerRadius: CGFloat

    @State private var isMultiline = false

    var body: some View {
        HStack(alignment: isMultiline ? .top : .center, spacing: iconTextGap) {
            icon

            Text(description)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    GeometryReader { geo in
                        // Caption regular line-height is ~18pt; if height > 20 → multi-line
                        Color.clear
                            .onAppear { isMultiline = geo.size.height > 20 }
                            .onChange(of: geo.size.height) { newHeight in
                                isMultiline = newHeight > 20
                            }
                    }
                )
        }
        .padding(padding)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(style.backgroundColor)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Previews

#if DEBUG
#Preview("With Buttons — All Styles") {
    ScrollView {
        VStack(spacing: ADIBSizes.Spacing.medium) {
            ADIBBanner(
                size: .withButtons,
                icon: Image(systemName: "info.circle.fill"),
                title: "Headline here",
                description: "You can add no more than three lines of content in this banner.",
                style: .info,
                primaryButtonTitle: "Continue",
                secondaryButtonTitle: "Get help",
                onPrimaryButton: { print("Continue") },
                onSecondaryButton: { print("Get help") }
            )

            ADIBBanner(
                size: .withButtons,
                icon: Image(systemName: "checkmark.circle.fill"),
                title: "Headline here",
                description: "You can add no more than three lines of content in this banner.",
                style: .success,
                primaryButtonTitle: "Continue",
                secondaryButtonTitle: "Get help",
                onPrimaryButton: { print("Continue") },
                onSecondaryButton: { print("Get help") }
            )

            ADIBBanner(
                size: .withButtons,
                icon: Image(systemName: "xmark.circle.fill"),
                title: "Headline here",
                description: "You can add no more than three lines of content in this banner.",
                style: .error,
                primaryButtonTitle: "Continue",
                secondaryButtonTitle: "Get help",
                onPrimaryButton: { print("Continue") },
                onSecondaryButton: { print("Get help") }
            )

            ADIBBanner(
                size: .withButtons,
                icon: Image(systemName: "exclamationmark.triangle.fill"),
                title: "Headline here",
                description: "You can add no more than three lines of content in this banner.",
                style: .warning,
                primaryButtonTitle: "Continue",
                secondaryButtonTitle: "Get help",
                onPrimaryButton: { print("Continue") },
                onSecondaryButton: { print("Get help") }
            )
        }
        .padding(.horizontal, ADIBSizes.Spacing.medium)
        .padding(.vertical, ADIBSizes.Spacing.large)
    }
    .background(ADIBColors.background)
}

#Preview("With Heading — All Styles") {
    VStack(spacing: ADIBSizes.Spacing.medium) {
        ADIBBanner(
            size: .withHeading,
            icon: Image(systemName: "info.circle.fill"),
            title: "Headline here",
            description: "You can add no more than three lines of content in this banner.",
            style: .info
        )

        ADIBBanner(
            size: .withHeading,
            icon: Image(systemName: "checkmark.circle.fill"),
            title: "Headline here",
            description: "You can add no more than three lines of content in this banner.",
            style: .success
        )

        ADIBBanner(
            size: .withHeading,
            icon: Image(systemName: "xmark.circle.fill"),
            title: "Headline here",
            description: "You can add no more than three lines of content in this banner.",
            style: .error
        )

        ADIBBanner(
            size: .withHeading,
            icon: Image(systemName: "exclamationmark.triangle.fill"),
            title: "Headline here",
            description: "You can add no more than three lines of content in this banner.",
            style: .warning
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("No Heading — All Styles") {
    VStack(spacing: ADIBSizes.Spacing.medium) {
        ADIBBanner(
            size: .noHeading,
            icon: Image(systemName: "info.circle.fill"),
            description: "You can add no more than three lines of content in this banner.",
            style: .info
        )

        ADIBBanner(
            size: .noHeading,
            icon: Image(systemName: "checkmark.circle.fill"),
            description: "You can add no more than three lines of content in this banner.",
            style: .success
        )

        ADIBBanner(
            size: .noHeading,
            icon: Image(systemName: "xmark.circle.fill"),
            description: "You can add no more than three lines of content in this banner.",
            style: .error
        )

        ADIBBanner(
            size: .noHeading,
            icon: Image(systemName: "exclamationmark.triangle.fill"),
            description: "You can add no more than three lines of content in this banner.",
            style: .warning
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Single Button") {
    ADIBBanner(
        size: .withButtons,
        icon: Image(systemName: "info.circle.fill"),
        title: "Headline here",
        description: "You can add no more than three lines of content in this banner.",
        style: .info,
        primaryButtonTitle: "Continue",
        onPrimaryButton: { print("Continue") }
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
