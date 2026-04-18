import SwiftUI

// MARK: - Status Type

/// The status variant for the indicator.
public enum ADIBStatusType {
    /// Green dot — active, completed.
    case active

    /// Amber dot — in progress, frozen.
    case inProgress

    /// Red dot — dormant, inactive, blocked.
    case inactive

    /// The dot color for this status.
    var dotColor: Color {
        switch self {
        case .active:     return ADIBColors.Semantic.Success.two
        case .inProgress: return ADIBColors.Semantic.Warning.two
        case .inactive:   return ADIBColors.Semantic.Error.two
        }
    }
}

// MARK: - Status Indicator Component

/// A compact status indicator from the ADIB design system.
///
/// Displays a text label with a colored dot indicating the current status.
///
/// ```swift
/// ADIBStatusIndicator(status: .active, text: "Active")
/// ADIBStatusIndicator(status: .inProgress, text: "Frozen")
/// ADIBStatusIndicator(status: .inactive, text: "Blocked")
/// ```
public struct ADIBStatusIndicator: View {

    // MARK: - Properties

    private let status: ADIBStatusType
    private let text: String

    // MARK: - Constants

    private let dotSize: CGFloat = 11
    private let gap: CGFloat = ADIBSizes.Spacing.small                         // 8

    // MARK: - Init

    /// Creates a status indicator.
    /// - Parameters:
    ///   - status: The status type (active, inProgress, inactive).
    ///   - text: The status label text (e.g. "Active", "Frozen", "Blocked").
    public init(
        status: ADIBStatusType,
        text: String
    ) {
        self.status = status
        self.text = text
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: gap) {
            Text(text)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.base)
                .lineLimit(1)

            Circle()
                .fill(status.dotColor)
                .frame(width: dotSize, height: dotSize)
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Status Indicators") {
    VStack(alignment: .trailing, spacing: ADIBSizes.Spacing.medium) {
        ADIBStatusIndicator(status: .active, text: "Active")
        ADIBStatusIndicator(status: .inProgress, text: "In progress")
        ADIBStatusIndicator(status: .inactive, text: "Blocked")
    }
    .padding()
    .background(ADIBColors.background)
}
#endif
