import SwiftUI

// MARK: - Banner Style

/// The visual style for the banner background.
public enum ADIBBannerStyle {
    /// Info style — light blue background (`ADIBColors.Banners.Info.background`).
    case info
    /// Success style — green background (`ADIBColors.Banners.Success.background`).
    case success
    /// Error style — red background (`ADIBColors.Banners.Error.background`).
    case error
    /// Warning style — yellow background (`ADIBColors.Banners.Warning.background`).
    case warning

    /// The background color for this style.
    var backgroundColor: Color {
        switch self {
        case .info:    return ADIBColors.Banners.Info.background
        case .success: return ADIBColors.Banners.Success.background
        case .error:   return ADIBColors.Banners.Error.background
        case .warning: return ADIBColors.Banners.Warning.background
        }
    }
}

// MARK: - Banner Component

/// A compact banner component from the ADIB design system.
///
/// Displays an icon, title, and description in a rounded container.
/// Commonly used for contextual messages like frequent beneficiaries,
/// promotions, or status notifications.
///
/// ```swift
/// ADIBBanner(
///     icon: Image("timer"),
///     title: "Frequent beneficiaries",
///     description: "Easily and quickly transfer to your frequently transferred beneficiaries",
///     style: .info
/// ) {
///     print("Banner tapped")
/// }
/// ```
public struct ADIBBanner: View {

    // MARK: - Properties

    private let icon: Image
    private let title: String
    private let description: String
    private let style: ADIBBannerStyle
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let containerPadding: CGFloat = ADIBSizes.Spacing.small          // 8
    private let containerRadius: CGFloat = ADIBSizes.Radius.medium           // 16
    private let iconBoxSize: CGFloat = 60
    private let iconSize: CGFloat = 32
    private let iconBoxRadius: CGFloat = ADIBSizes.Radius.small              // 12
    private let contentGap: CGFloat = 12
    private let textGap: CGFloat = ADIBSizes.Spacing.xxsmall                 // 2

    // MARK: - Init

    /// Creates a banner component.
    /// - Parameters:
    ///   - icon: The leading icon image.
    ///   - title: The bold title text.
    ///   - description: The secondary description text.
    ///   - style: The banner visual style (default `.info`).
    ///   - onTap: An optional tap action.
    public init(
        icon: Image,
        title: String,
        description: String,
        style: ADIBBannerStyle = .info,
        onTap: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.style = style
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if let onTap {
                Button(action: onTap) {
                    content
                }
                .buttonStyle(.plain)
            } else {
                content
            }
        }
    }

    private var content: some View {
        HStack(spacing: contentGap) {
            // Icon box
            icon
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(ADIBColors.Segment.accent)
                .frame(width: iconBoxSize, height: iconBoxSize)
                .background(
                    RoundedRectangle(cornerRadius: iconBoxRadius)
                        .fill(Color.clear)
                )

            // Text content
            VStack(alignment: .leading, spacing: textGap) {
                Text(title)
                    .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                    .lineLimit(1)

                Text(description)
                    .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(containerPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: containerRadius)
                .fill(style.backgroundColor)
        )
        .clipShape(RoundedRectangle(cornerRadius: containerRadius))
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Banner") {
    VStack(spacing: ADIBSizes.Spacing.medium) {
        ADIBBanner(
            icon: Image(systemName: "clock.fill"),
            title: "Frequent beneficiaries",
            description: "Easily and quickly transfer to your frequently transferred beneficiaries",
            style: .info
        )

        ADIBBanner(
            icon: Image(systemName: "checkmark.circle.fill"),
            title: "Transfer successful",
            description: "Your transfer has been completed successfully",
            style: .success
        )

        ADIBBanner(
            icon: Image(systemName: "exclamationmark.triangle.fill"),
            title: "Action required",
            description: "Please verify your identity to continue",
            style: .warning
        )

        ADIBBanner(
            icon: Image(systemName: "xmark.circle.fill"),
            title: "Transfer failed",
            description: "Something went wrong, please try again",
            style: .error
        )
    }
    .padding()
    .background(ADIBColors.background)
}
#endif
