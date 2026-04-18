import SwiftUI

// MARK: - Page Header Size

/// The size variant for the page header.
public enum ADIBPageHeaderSize {
    /// Large header — 32pt heading (H1), progress bar, step counter.
    case large
    /// Compact header — inline navigation bar with centered title.
    case compact(ADIBCompactHeaderType)
}

// MARK: - Compact Header Type

/// The sub-variant for a compact page header.
public enum ADIBCompactHeaderType {
    /// Centered title with a right-aligned CTA text button (e.g. "Done").
    case withCTA
    /// Centered title with a right-aligned icon (e.g. help-circle).
    case withIcon
    /// Centered title with a subheading below it, and a right-aligned icon.
    case titleSubheading
}

// MARK: - Page Header Component

/// A page header component from the ADIB design system.
///
/// Supports two size variants:
///
/// **Large** — Full page header with optional progress bar, navigation row,
/// step counter, heading (H1), and description.
///
/// **Compact** — Inline navigation bar with back button, centered title,
/// and a trailing element (CTA text, icon, or subheading).
///
/// ```swift
/// // Large
/// ADIBPageHeader(
///     heading: "Transfer details",
///     description: "Enter the transfer amount and details",
///     showProgressBar: true,
///     progress: 0.27,
///     showSteps: true,
///     currentStep: 1,
///     totalSteps: 5,
///     onBack: { dismiss() }
/// )
///
/// // Compact with CTA
/// ADIBPageHeader(
///     size: .compact(.withCTA),
///     heading: "Title",
///     ctaText: "Done",
///     onCTA: { save() },
///     onBack: { dismiss() }
/// )
///
/// // Compact with icon
/// ADIBPageHeader(
///     size: .compact(.withIcon),
///     heading: "Title",
///     trailingIcon: Image("help-circle"),
///     onTrailingIcon: { showHelp() },
///     onBack: { dismiss() }
/// )
///
/// // Compact with subheading
/// ADIBPageHeader(
///     size: .compact(.titleSubheading),
///     heading: "Title",
///     subheading: "Subheading",
///     trailingIcon: Image("help-circle"),
///     onBack: { dismiss() }
/// )
/// ```
public struct ADIBPageHeader: View {

    // MARK: - Properties

    private let size: ADIBPageHeaderSize
    private let heading: String
    private let description: String?
    private let subheading: String?
    private let showDescription: Bool
    private let showProgressBar: Bool
    private let progress: CGFloat
    private let showNavigation: Bool
    private let showBack: Bool
    private let showSteps: Bool
    private let currentStep: Int
    private let totalSteps: Int
    private let backIcon: Image?
    private let onBack: (() -> Void)?

    // Compact-specific
    private let ctaText: String?
    private let showCTA: Bool
    private let onCTA: (() -> Void)?
    private let trailingIcon: Image?
    private let showTrailingIcon: Bool
    private let onTrailingIcon: (() -> Void)?

    // MARK: - Shared Constants

    private let horizontalPadding: CGFloat = ADIBSizes.Spacing.medium      // 16
    private let backIconSize: CGFloat = ADIBSizes.Spacing.large            // 24

    // MARK: - Large Constants

    private let sectionGap: CGFloat = 10
    private let headingDescriptionGap: CGFloat = ADIBSizes.Spacing.small   // 8
    private let progressBarHeight: CGFloat = 4
    private let progressBarRadius: CGFloat = 19
    private let navRowHeight: CGFloat = 40
    private let stepBadgeSize: CGFloat = 40

    // MARK: - Compact Constants

    private let compactBarHeight: CGFloat = 44
    private let compactIconSize: CGFloat = ADIBSizes.Spacing.large         // 24

    // MARK: - Init

    /// Creates a page header.
    /// - Parameters:
    ///   - size: The header size variant (default `.large`).
    ///   - heading: The main heading text (or centered title for compact).
    ///   - description: The optional description text below the heading (large only).
    ///   - subheading: The optional subheading below the title (compact titleSubheading only).
    ///   - showDescription: Whether to show the description (default `true`).
    ///   - showProgressBar: Whether to show the progress bar (default `true`, large only).
    ///   - progress: The progress value from 0.0 to 1.0 (default `0.0`).
    ///   - showNavigation: Whether to show the navigation row (default `true`, large only).
    ///   - showBack: Whether to show the back button (default `true`).
    ///   - showSteps: Whether to show the step counter (default `true`, large only).
    ///   - currentStep: The current step number (default `0`).
    ///   - totalSteps: The total number of steps (default `0`).
    ///   - backIcon: Custom back icon image. Falls back to SF Symbol `chevron.left`.
    ///   - ctaText: The CTA button text (compact withCTA only).
    ///   - showCTA: Whether to show the CTA text (default `true`).
    ///   - onCTA: The action for the CTA button tap.
    ///   - trailingIcon: The trailing icon (compact withIcon/titleSubheading).
    ///   - showTrailingIcon: Whether to show the trailing icon (default `true`).
    ///   - onTrailingIcon: The action for the trailing icon tap.
    ///   - onBack: The action for the back button tap.
    public init(
        size: ADIBPageHeaderSize = .large,
        heading: String,
        description: String? = nil,
        subheading: String? = nil,
        showDescription: Bool = true,
        showProgressBar: Bool = true,
        progress: CGFloat = 0.0,
        showNavigation: Bool = true,
        showBack: Bool = true,
        showSteps: Bool = true,
        currentStep: Int = 0,
        totalSteps: Int = 0,
        backIcon: Image? = nil,
        ctaText: String? = nil,
        showCTA: Bool = true,
        onCTA: (() -> Void)? = nil,
        trailingIcon: Image? = nil,
        showTrailingIcon: Bool = true,
        onTrailingIcon: (() -> Void)? = nil,
        onBack: (() -> Void)? = nil
    ) {
        self.size = size
        self.heading = heading
        self.description = description
        self.subheading = subheading
        self.showDescription = showDescription
        self.showProgressBar = showProgressBar
        self.progress = progress
        self.showNavigation = showNavigation
        self.showBack = showBack
        self.showSteps = showSteps
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.backIcon = backIcon
        self.ctaText = ctaText
        self.showCTA = showCTA
        self.onCTA = onCTA
        self.trailingIcon = trailingIcon
        self.showTrailingIcon = showTrailingIcon
        self.onTrailingIcon = onTrailingIcon
        self.onBack = onBack
    }

    // MARK: - Body

    public var body: some View {
        switch size {
        case .large:
            largeBody
        case .compact:
            compactBody
        }
    }

    // =========================================================================
    // MARK: - LARGE VARIANT
    // =========================================================================

    private var largeBody: some View {
        VStack(spacing: sectionGap) {
            if showProgressBar {
                progressBarView
            }
            if showNavigation {
                largeNavigationRow
            }
            headingBlock
        }
        .padding(.horizontal, horizontalPadding)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Progress Bar

    private var progressBarView: some View {
        ZStack(alignment: .leading) {
            // Track
            RoundedRectangle(cornerRadius: progressBarRadius)
                .fill(ADIBColors.Inputs.background)
                .frame(height: progressBarHeight)

            // Fill
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: progressBarRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                ADIBColors.Gradients.Colors.oneStart,
                                ADIBColors.Gradients.Colors.oneEnd
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * min(max(progress, 0), 1))
            }
            .frame(height: progressBarHeight)
        }
        .frame(maxWidth: .infinity)
        .frame(height: progressBarHeight)
    }

    // MARK: - Large Navigation Row

    private var largeNavigationRow: some View {
        HStack(spacing: sectionGap) {
            // Back button
            Button {
                onBack?()
            } label: {
                backIconView
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: navRowHeight)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Step counter
            if showSteps {
                stepCounter
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Step Counter

    private var stepCounter: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text("\(currentStep)")
                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)

            Text("/\(String(format: "%02d", totalSteps))")
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Inputs.placeholder)
        }
        .frame(width: stepBadgeSize, height: stepBadgeSize)
    }

    // MARK: - Heading Block

    private var headingBlock: some View {
        VStack(alignment: .leading, spacing: headingDescriptionGap) {
            Text(heading)
                .adibTextStyle(ADIBTypography.h1.semibold, color: ADIBColors.Text.base)
                .frame(maxWidth: .infinity, alignment: .leading)

            if showDescription, let description, !description.isEmpty {
                Text(description)
                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.subdued)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // =========================================================================
    // MARK: - COMPACT VARIANT
    // =========================================================================

    private var compactBody: some View {
        HStack(spacing: 0) {
            // Leading: Back button
            if showBack {
                Button {
                    onBack?()
                } label: {
                    backIconView
                        .frame(width: compactIconSize, height: compactIconSize)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                Spacer()
                    .frame(width: compactIconSize)
            }

            Spacer()

            // Center: Title (+ optional subheading)
            compactCenterContent

            Spacer()

            // Trailing: CTA or Icon
            compactTrailingContent
        }
        .frame(height: compactBarHeight)
        .padding(.horizontal, horizontalPadding)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Compact Center Content

    @ViewBuilder
    private var compactCenterContent: some View {
        if case .compact(.titleSubheading) = size {
            VStack(spacing: 0) {
                Text(heading)
                    .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                    .lineLimit(1)

                if let subheading, !subheading.isEmpty {
                    Text(subheading)
                        .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                        .lineLimit(1)
                }
            }
        } else {
            Text(heading)
                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                .lineLimit(1)
        }
    }

    // MARK: - Compact Trailing Content

    @ViewBuilder
    private var compactTrailingContent: some View {
        if case .compact(.withCTA) = size {
            if showCTA, let ctaText, !ctaText.isEmpty {
                Button {
                    onCTA?()
                } label: {
                    Text(ctaText)
                        .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.interaction)
                        .lineLimit(1)
                }
                .buttonStyle(.plain)
            } else {
                Spacer()
                    .frame(width: compactIconSize)
            }
        } else {
            if showTrailingIcon {
                Button {
                    onTrailingIcon?()
                } label: {
                    (trailingIcon ?? Image(systemName: "questionmark.circle"))
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: compactIconSize, height: compactIconSize)
                        .foregroundStyle(ADIBColors.interaction)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                Spacer()
                    .frame(width: compactIconSize)
            }
        }
    }

    // MARK: - Shared Back Icon

    private var backIconView: some View {
        (backIcon ?? Image("chevron-left", bundle: .module))
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: backIconSize, height: backIconSize)
            .foregroundStyle(ADIBColors.Text.base)
    }
}

// MARK: - Previews

#if DEBUG

// MARK: Large Previews

#Preview("Large — All Options") {
    VStack {
        ADIBPageHeader(
            heading: "Transfer details",
            description: "Enter the beneficiary details to make a transfer",
            showProgressBar: true,
            progress: 0.27,
            showSteps: true,
            currentStep: 1,
            totalSteps: 5,
            onBack: {}
        )
        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Large — No Progress") {
    VStack {
        ADIBPageHeader(
            heading: "Beneficiary details",
            description: "Page description goes here",
            showProgressBar: false,
            showSteps: true,
            currentStep: 3,
            totalSteps: 5,
            onBack: {}
        )
        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Large — Heading Only") {
    VStack {
        ADIBPageHeader(
            heading: "Settings",
            showDescription: false,
            showProgressBar: false,
            showSteps: false,
            onBack: {}
        )
        Spacer()
    }
    .background(ADIBColors.background)
}

// MARK: Compact Previews

#Preview("Compact — With CTA") {
    VStack {
        ADIBPageHeader(
            size: .compact(.withCTA),
            heading: "Title",
            ctaText: "Done",
            onCTA: {},
            onBack: {}
        )
        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Compact — With Icon") {
    VStack {
        ADIBPageHeader(
            size: .compact(.withIcon),
            heading: "Title",
            onBack: {}
        )
        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Compact — Title+Subheading") {
    VStack {
        ADIBPageHeader(
            size: .compact(.titleSubheading),
            heading: "Title",
            subheading: "Subheading",
            onBack: {}
        )
        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Compact — No Back") {
    VStack {
        ADIBPageHeader(
            size: .compact(.withCTA),
            heading: "Title",
            showBack: false,
            ctaText: "Done",
            onCTA: {}
        )
        Spacer()
    }
    .background(ADIBColors.background)
}
#endif
