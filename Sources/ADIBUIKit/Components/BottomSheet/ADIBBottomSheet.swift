import SwiftUI

// MARK: - Bottom Sheet Component

/// A bottom sheet container from the ADIB design system.
///
/// Provides a styled container with rounded top corners, optional close button,
/// optional illustration, heading, description, a detail card, and button actions.
/// Present using SwiftUI's native `.sheet` modifier for standard iOS behaviour.
///
/// ```swift
/// .sheet(isPresented: $showSheet) {
///     ADIBBottomSheet(
///         heading: "Check the name",
///         description: "Is the beneficiary name as expected?",
///         illustration: Image(systemName: "exclamationmark.triangle.fill"),
///         onClose: { showSheet = false }
///     ) {
///         // Custom content
///     } actions: {
///         PrimaryButton("Continue") { }
///         TertiaryButton("Edit", showIcon: false) { }
///     }
/// }
/// ```
public struct ADIBBottomSheet<Content: View, Actions: View>: View {

    // MARK: - Properties

    private let heading: String
    private let description: String?
    private let illustration: Image?
    private let showCloseButton: Bool
    private let onClose: (() -> Void)?
    private let content: Content
    private let actions: Actions

    // MARK: - Constants

    private let sheetRadius: CGFloat = 30
    private let topPadding: CGFloat = 20
    private let horizontalPadding: CGFloat = ADIBSizes.Spacing.medium     // 16 → will use 20 for content
    private let contentHorizontalPadding: CGFloat = 20
    private let sectionGap: CGFloat = ADIBSizes.Spacing.large             // 24
    private let innerGap: CGFloat = ADIBSizes.Spacing.medium              // 16
    private let headingDescGap: CGFloat = ADIBSizes.Spacing.small         // 8
    private let closeIconSize: CGFloat = ADIBSizes.Spacing.large          // 24
    private let illustrationHeight: CGFloat = 158

    // MARK: - Init

    /// Creates a bottom sheet.
    /// - Parameters:
    ///   - heading: The main heading text (centered).
    ///   - description: Optional description text below the heading (centered).
    ///   - illustration: Optional illustration image shown above the heading.
    ///   - showCloseButton: Whether to show the close (X) button (default `true`).
    ///   - onClose: Action when the close button is tapped.
    ///   - content: Custom content view placed between the description and the actions.
    ///   - actions: Action buttons at the bottom (e.g. PrimaryButton, TertiaryButton).
    public init(
        heading: String,
        description: String? = nil,
        illustration: Image? = nil,
        showCloseButton: Bool = true,
        onClose: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder actions: () -> Actions
    ) {
        self.heading = heading
        self.description = description
        self.illustration = illustration
        self.showCloseButton = showCloseButton
        self.onClose = onClose
        self.content = content()
        self.actions = actions()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: sectionGap) {
            // Top area: illustration + close button
            topSection

            // Heading + description + content
            VStack(spacing: innerGap) {
                // Heading & description
                VStack(spacing: headingDescGap) {
                    Text(heading)
                        .adibTextStyle(ADIBTypography.h1.semibold, color: ADIBColors.Text.base)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    if let description, !description.isEmpty {
                        Text(description)
                            .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.subdued)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                }

                // Custom content
                content
            }
            .padding(.horizontal, contentHorizontalPadding)

            // Action buttons
            VStack(spacing: 0) {
                actions
            }
            .padding(.horizontal, contentHorizontalPadding)
        }
        .padding(.top, topPadding)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }

    // MARK: - Top Section

    @ViewBuilder
    private var topSection: some View {
        ZStack(alignment: .topTrailing) {
            // Illustration
            if let illustration {
                illustration
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: illustrationHeight)
                    .frame(maxWidth: .infinity)
            }

            // Close button
            if showCloseButton {
                Button {
                    onClose?()
                } label: {
                    Image(systemName: "xmark")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: closeIconSize, height: closeIconSize)
                        .foregroundStyle(ADIBColors.Text.base)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.trailing, contentHorizontalPadding)
            }
        }
    }
}

// MARK: - Convenience Init (No Content)

extension ADIBBottomSheet where Content == EmptyView {
    /// Creates a bottom sheet without custom content.
    public init(
        heading: String,
        description: String? = nil,
        illustration: Image? = nil,
        showCloseButton: Bool = true,
        onClose: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.heading = heading
        self.description = description
        self.illustration = illustration
        self.showCloseButton = showCloseButton
        self.onClose = onClose
        self.content = EmptyView()
        self.actions = actions()
    }
}

// MARK: - Detail Card

/// A detail card used inside bottom sheets, showing label + value pairs.
///
/// ```swift
/// ADIBDetailCard {
///     ADIBDetailCardRow(label: "Name", value: "ZAYED IBRAHIM")
/// }
/// ```
public struct ADIBDetailCard<Content: View>: View {

    private let content: Content

    private let cardRadius: CGFloat = ADIBSizes.Radius.default            // 20
    private let verticalPadding: CGFloat = 12
    private let horizontalPadding: CGFloat = 20
    private let rowGap: CGFloat = 12

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: rowGap) {
            content
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: cardRadius)
                .fill(ADIBColors.Surface.blueTwo)
        )
    }
}

/// A single label + value row for use inside `ADIBDetailCard`.
public struct ADIBDetailCardRow: View {

    private let label: String
    private let value: String

    private let textGap: CGFloat = ADIBSizes.Spacing.xsmall              // 4

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: textGap) {
            Text(label)
                .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)

            Text(value)
                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Bottom Sheet") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            ADIBBottomSheet(
                heading: "Check the name",
                description: "Is the beneficiary name as expected?",
                illustration: Image(systemName: "exclamationmark.triangle.fill"),
                onClose: {}
            ) {
                ADIBDetailCard {
                    ADIBDetailCardRow(
                        label: "Actual beneficiary name",
                        value: "ZAYED IBRAHIM FAHAD"
                    )
                }
            } actions: {
                PrimaryButton("Continue") {}
                TertiaryButton("Edit beneficiary details", showIcon: false) {}
            }
        }
}
#endif
