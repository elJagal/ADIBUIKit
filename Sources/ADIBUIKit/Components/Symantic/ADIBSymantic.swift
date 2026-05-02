import SwiftUI

// MARK: - Symantic Type

/// The semantic status variant for the full-screen status template.
public enum ADIBSymanticType {
    /// Green success illustration — used after a successful action
    /// (e.g. "Beneficiary added successfully", "Transfer processed").
    case success

    /// Orange warning illustration — used to draw attention to something
    /// that needs the user's confirmation (e.g. "Check the name").
    case warning

    /// Paper-plane / send illustration — used after a successful transfer.
    case transferSuccess

    // MARK: Internal

    /// The illustration asset name in the package bundle.
    fileprivate var illustrationName: String {
        switch self {
        case .success:          return "symantic-success"
        case .warning:          return "symantic-warning"
        case .transferSuccess:  return "symantic-transfer-success"
        }
    }
}

// MARK: - Symantic Component

/// A full-screen semantic status template from the ADIB design system.
///
/// Displays a centered illustration, headline, optional description,
/// and an action button group at the bottom of the screen. Used for
/// success, warning, and error states throughout the app.
///
/// ```swift
/// ADIBSymantic(
///     type: .success,
///     heading: "Beneficiary added\nsuccessfully!"
/// ) {
///     PrimaryButton("Transfer money now") { /* ... */ }
///     SecondaryButton("Done") { /* ... */ }
/// }
/// ```
///
/// Or use as a centered illustration block (no fixed layout):
///
/// ```swift
/// ADIBSymantic.Illustration(type: .warning)
/// ```
public struct ADIBSymantic<Actions: View>: View {

    // MARK: - Properties

    private let type: ADIBSymanticType
    private let heading: String
    private let description: String?
    private let actions: Actions

    // MARK: - Constants

    private let illustrationSize: CGFloat = 238
    private let warningIllustrationSize: CGFloat = 156
    private let headingDescriptionGap: CGFloat = ADIBSizes.Spacing.small      // 8
    private let illustrationHeadingGap: CGFloat = ADIBSizes.Spacing.large    // 24
    private let bottomPadding: CGFloat = ADIBSizes.Spacing.xlarge            // 32

    // MARK: - Init

    /// Creates a full-screen semantic status template.
    /// - Parameters:
    ///   - type: The semantic variant (`.success`, `.warning`, `.transferSuccess`).
    ///   - heading: The main heading (typically H1).
    ///   - description: Optional description text below the heading.
    ///   - actions: A view-builder of action buttons (Primary / Secondary / Tertiary).
    public init(
        type: ADIBSymanticType,
        heading: String,
        description: String? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.type = type
        self.heading = heading
        self.description = description
        self.actions = actions()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Illustration + heading + description
            VStack(spacing: illustrationHeadingGap) {
                ADIBSymanticIllustration(type: type)

                VStack(spacing: headingDescriptionGap) {
                    Text(heading)
                        .adibTextStyle(ADIBTypography.h1.semibold, color: ADIBColors.Text.base)
                        .multilineTextAlignment(.center)

                    if let description, !description.isEmpty {
                        Text(description)
                            .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.subdued)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, ADIBSizes.Spacing.medium)
            }

            Spacer()

            // Action buttons at the bottom
            VStack(spacing: 0) {
                actions
            }
            .padding(.horizontal, ADIBSizes.Spacing.medium)
            .padding(.bottom, bottomPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ADIBColors.background)
    }
}

// MARK: - Illustration-Only Variant

/// Just the illustration block (no heading / actions).
/// Useful inside containers like `ADIBBottomSheet` where the sheet
/// already provides the heading + description + actions.
public struct ADIBSymanticIllustration: View {

    private let type: ADIBSymanticType
    private let size: CGFloat

    public init(type: ADIBSymanticType, size: CGFloat? = nil) {
        self.type = type
        // Default sizes match the Figma source artwork
        switch type {
        case .warning:
            self.size = size ?? 156
        case .success, .transferSuccess:
            self.size = size ?? 238
        }
    }

    public var body: some View {
        Image(type.illustrationName, bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Symantic — Success") {
    ADIBSymantic(
        type: .success,
        heading: "Beneficiary added\nsuccessfully!"
    ) {
        PrimaryButton("Transfer money now") {}
        SecondaryButton("Done") {}
    }
}

#Preview("Symantic — Transfer Success") {
    ADIBSymantic(
        type: .transferSuccess,
        heading: "Transfer processed\nsuccessfully!",
        description: "AED 1,000.00 has been sent to\nMohammed Saleh"
    ) {
        PrimaryButton("Done") {}
        TertiaryButton("View Receipt", showIcon: false) {}
    }
}

#Preview("Symantic — Warning (illustration only)") {
    ADIBSymanticIllustration(type: .warning)
        .padding()
        .background(ADIBColors.background)
}
#endif
