import SwiftUI

// MARK: - Page Header Size

/// The size variant for the page header.
public enum ADIBPageHeaderSize {
    /// Large header — 32pt heading (H1), used for primary screens.
    case large
}

// MARK: - Page Header Component

/// A page header component from the ADIB design system.
///
/// Displays an optional progress bar, navigation row with back button
/// and step counter, a heading, and an optional description.
///
/// All sub-elements can be toggled on/off via boolean properties.
///
/// ```swift
/// ADIBPageHeader(
///     heading: "Transfer details",
///     description: "Enter the transfer amount and details",
///     showProgressBar: true,
///     progress: 0.27,
///     showNavigation: true,
///     showSteps: true,
///     currentStep: 1,
///     totalSteps: 5,
///     onBack: { dismiss() }
/// )
/// ```
public struct ADIBPageHeader: View {

    // MARK: - Properties

    private let size: ADIBPageHeaderSize
    private let heading: String
    private let description: String?
    private let showDescription: Bool
    private let showProgressBar: Bool
    private let progress: CGFloat
    private let showNavigation: Bool
    private let showSteps: Bool
    private let currentStep: Int
    private let totalSteps: Int
    private let backIcon: Image?
    private let onBack: (() -> Void)?

    // MARK: - Constants

    private let contentWidth: CGFloat = 335
    private let navigationWidth: CGFloat = 344
    private let sectionGap: CGFloat = 10
    private let headingDescriptionGap: CGFloat = ADIBSizes.Spacing.small   // 8
    private let progressBarHeight: CGFloat = 4
    private let progressBarRadius: CGFloat = 19
    private let backIconSize: CGFloat = ADIBSizes.Spacing.large            // 24
    private let navRowHeight: CGFloat = 40
    private let stepBadgeSize: CGFloat = 40

    // MARK: - Init

    /// Creates a page header.
    /// - Parameters:
    ///   - size: The header size variant (default `.large`).
    ///   - heading: The main heading text.
    ///   - description: The optional description text below the heading.
    ///   - showDescription: Whether to show the description (default `true`).
    ///   - showProgressBar: Whether to show the progress bar (default `true`).
    ///   - progress: The progress value from 0.0 to 1.0 (default `0.0`).
    ///   - showNavigation: Whether to show the navigation row with back button (default `true`).
    ///   - showSteps: Whether to show the step counter (default `true`).
    ///   - currentStep: The current step number (default `0`).
    ///   - totalSteps: The total number of steps (default `0`).
    ///   - backIcon: Custom back icon image. Pass your app's `chevron-left` asset here.
    ///   - onBack: The action to perform when the back button is tapped.
    public init(
        size: ADIBPageHeaderSize = .large,
        heading: String,
        description: String? = nil,
        showDescription: Bool = true,
        showProgressBar: Bool = true,
        progress: CGFloat = 0.0,
        showNavigation: Bool = true,
        showSteps: Bool = true,
        currentStep: Int = 0,
        totalSteps: Int = 0,
        backIcon: Image? = nil,
        onBack: (() -> Void)? = nil
    ) {
        self.size = size
        self.heading = heading
        self.description = description
        self.showDescription = showDescription
        self.showProgressBar = showProgressBar
        self.progress = progress
        self.showNavigation = showNavigation
        self.showSteps = showSteps
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.backIcon = backIcon
        self.onBack = onBack
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: sectionGap) {

            // MARK: - Progress Bar
            if showProgressBar {
                progressBarView
            }

            // MARK: - Navigation Row
            if showNavigation {
                navigationRow
            }

            // MARK: - Heading + Description
            headingBlock
        }
        .frame(maxWidth: .infinity)
        .background(ADIBColors.background)
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
        .frame(width: contentWidth, height: progressBarHeight)
    }

    // MARK: - Navigation Row

    private var navigationRow: some View {
        HStack(spacing: sectionGap) {
            // Back button
            Button {
                onBack?()
            } label: {
                (backIcon ?? Image(systemName: "chevron.left"))
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: backIconSize, height: backIconSize)
                    .foregroundStyle(ADIBColors.Text.base)
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
        .frame(width: navigationWidth)
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
        .frame(width: contentWidth)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Page Header — All Options") {
    VStack {
        ADIBPageHeader(
            heading: "Transfer details",
            description: "Enter the beneficiary details to make a transfer",
            showProgressBar: true,
            progress: 0.27,
            showNavigation: true,
            showSteps: true,
            currentStep: 1,
            totalSteps: 5,
            onBack: {}
        )

        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Page Header — No Progress") {
    VStack {
        ADIBPageHeader(
            heading: "Beneficiary details",
            description: "Page description goes here",
            showProgressBar: false,
            showNavigation: true,
            showSteps: true,
            currentStep: 3,
            totalSteps: 5,
            onBack: {}
        )

        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Page Header — Heading Only") {
    VStack {
        ADIBPageHeader(
            heading: "Settings",
            showDescription: false,
            showProgressBar: false,
            showNavigation: true,
            showSteps: false,
            onBack: {}
        )

        Spacer()
    }
    .background(ADIBColors.background)
}

#Preview("Page Header — Minimal") {
    VStack {
        ADIBPageHeader(
            heading: "Welcome",
            description: "Let's get started with your account setup",
            showProgressBar: false,
            showNavigation: false,
            showSteps: false
        )

        Spacer()
    }
    .background(ADIBColors.background)
}
#endif
