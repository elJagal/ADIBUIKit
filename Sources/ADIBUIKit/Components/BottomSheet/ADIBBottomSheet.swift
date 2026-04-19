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
public struct ADIBBottomSheet<Illustration: View, Content: View, Actions: View>: View {

    // MARK: - Properties

    private let heading: String
    private let description: String?
    private let illustration: Illustration
    private let showCloseButton: Bool
    private let onClose: (() -> Void)?
    private let content: Content
    private let actions: Actions

    // MARK: - Constants

    private let sheetRadius: CGFloat = 30
    private let topPadding: CGFloat = 20
    private let contentHorizontalPadding: CGFloat = 20
    private let sectionGap: CGFloat = ADIBSizes.Spacing.large             // 24
    private let innerGap: CGFloat = ADIBSizes.Spacing.medium              // 16
    private let headingDescGap: CGFloat = ADIBSizes.Spacing.small         // 8
    private let closeIconSize: CGFloat = ADIBSizes.Spacing.large          // 24

    // MARK: - Init

    /// Creates a bottom sheet.
    /// - Parameters:
    ///   - heading: The main heading text (centered).
    ///   - description: Optional description text below the heading (centered).
    ///   - showCloseButton: Whether to show the close (X) button (default `true`).
    ///   - onClose: Action when the close button is tapped.
    ///   - illustration: Custom illustration view shown above the heading.
    ///   - content: Custom content view placed between the description and the actions.
    ///   - actions: Action buttons at the bottom (e.g. PrimaryButton, TertiaryButton).
    public init(
        heading: String,
        description: String? = nil,
        showCloseButton: Bool = true,
        onClose: (() -> Void)? = nil,
        @ViewBuilder illustration: () -> Illustration,
        @ViewBuilder content: () -> Content,
        @ViewBuilder actions: () -> Actions
    ) {
        self.heading = heading
        self.description = description
        self.showCloseButton = showCloseButton
        self.onClose = onClose
        self.illustration = illustration()
        self.content = content()
        self.actions = actions()
    }

    @State private var sheetHeight: CGFloat = 0

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Close button row
                if showCloseButton {
                    HStack {
                        Spacer()
                        Button {
                            onClose?()
                        } label: {
                            Image("x", bundle: .module)
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: closeIconSize, height: closeIconSize)
                                .foregroundStyle(ADIBColors.Text.base)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, contentHorizontalPadding)
                }

                // Illustration
                illustration
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .padding(.top, ADIBSizes.Spacing.small)

                // Heading + description + content
                VStack(spacing: innerGap) {
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

                    content
                }
                .padding(.horizontal, contentHorizontalPadding)
                .padding(.top, innerGap)

                // Action buttons
                VStack(spacing: 0) {
                    actions
                }
                .padding(.horizontal, contentHorizontalPadding)
                .padding(.top, sectionGap)
            }
            .padding(.top, topPadding)
            .padding(.bottom, sectionGap)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: SheetHeightKey.self,
                        value: geo.size.height
                    )
                }
            )
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .onPreferenceChange(SheetHeightKey.self) { sheetHeight = $0 }
        .presentationDetents([.height(sheetHeight)])
        .presentationDragIndicator(.hidden)
    }
}

// MARK: - Convenience Init (No Content)

extension ADIBBottomSheet where Illustration == EmptyView {
    /// Creates a bottom sheet without an illustration.
    public init(
        heading: String,
        description: String? = nil,
        showCloseButton: Bool = true,
        onClose: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder actions: () -> Actions
    ) {
        self.heading = heading
        self.description = description
        self.showCloseButton = showCloseButton
        self.onClose = onClose
        self.illustration = EmptyView()
        self.content = content()
        self.actions = actions()
    }
}

extension ADIBBottomSheet where Illustration == EmptyView, Content == EmptyView {
    /// Creates a bottom sheet without illustration or custom content.
    public init(
        heading: String,
        description: String? = nil,
        showCloseButton: Bool = true,
        onClose: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.heading = heading
        self.description = description
        self.showCloseButton = showCloseButton
        self.onClose = onClose
        self.illustration = EmptyView()
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

// MARK: - Sheet Height Preference Key

private struct SheetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
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
                onClose: {}
            ) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.orange)
            } content: {
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
