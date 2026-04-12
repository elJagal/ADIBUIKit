import SwiftUI

// MARK: - Tag Type

/// The visual style of a tag.
public enum ADIBTagType {
    case `default`
    case info
    case success
    case warning
    case error
    case selected
    case unselected
    case new

    var backgroundColor: Color {
        switch self {
        case .default:      return ADIBColors.Inputs.background
        case .info:         return ADIBColors.Semantic.Info.three
        case .success:      return ADIBColors.Semantic.Success.three
        case .warning:      return ADIBColors.Semantic.Warning.three
        case .error:        return ADIBColors.Semantic.Error.three
        case .selected:     return ADIBColors.interaction
        case .unselected:   return ADIBColors.Surface.components
        case .new:          return ADIBColors.Semantic.Success.two
        }
    }

    var textColor: Color {
        switch self {
        case .default:      return ADIBColors.Inputs.placeholder
        case .info:         return ADIBColors.Text.base
        case .success:      return ADIBColors.Semantic.Success.one
        case .warning:      return ADIBColors.Semantic.Warning.one
        case .error:        return ADIBColors.Semantic.Error.two
        case .selected:     return ADIBColors.Text.white
        case .unselected:   return ADIBColors.Inputs.placeholder
        case .new:          return ADIBColors.Text.white
        }
    }

    /// Whether this tag type supports leading/trailing icons
    var supportsIcons: Bool {
        switch self {
        case .new, .unselected: return false
        default:                return true
        }
    }
}

// MARK: - Tag Component

/// A compact label used to categorize, filter, or indicate status.
///
/// Supports 8 types: default, info, success, warning, error, selected, unselected, new.
///
/// ```swift
/// ADIBTag("Label", type: .info)
/// ADIBTag("Label", type: .default, leadingIcon: Image("timer"), onDismiss: { })
/// ADIBTag("New", type: .new)
/// ```
public struct ADIBTag: View {

    // MARK: - Properties

    private let text: String
    private let type: ADIBTagType
    private let leadingIcon: Image?
    private let showLeadingIcon: Bool
    private let trailingIcon: Image?
    private let showTrailingIcon: Bool
    private let onTrailingTap: (() -> Void)?

    // MARK: - Constants

    private let iconSize: CGFloat = ADIBSizes.Spacing.medium        // 16pt
    private let cornerRadius: CGFloat = ADIBSizes.Spacing.small     // 8pt
    private let horizontalPadding: CGFloat = ADIBSizes.Spacing.small // 8pt
    private let verticalPadding: CGFloat = ADIBSizes.Spacing.xsmall // 4pt
    private let contentSpacing: CGFloat = ADIBSizes.Spacing.small   // 8pt

    // MARK: - Init

    /// Creates a tag.
    /// - Parameters:
    ///   - text: The label text
    ///   - type: The tag style type
    ///   - leadingIcon: Optional leading icon image (only for types that support icons)
    ///   - showLeadingIcon: Toggle leading icon visibility (default `true`)
    ///   - trailingIcon: Optional trailing icon image (defaults to xmark)
    ///   - showTrailingIcon: Toggle trailing icon visibility (default `true`)
    ///   - onTrailingTap: Optional action for the trailing icon
    public init(
        _ text: String,
        type: ADIBTagType = .default,
        leadingIcon: Image? = nil,
        showLeadingIcon: Bool = true,
        trailingIcon: Image? = nil,
        showTrailingIcon: Bool = true,
        onTrailingTap: (() -> Void)? = nil
    ) {
        self.text = text
        self.type = type
        self.leadingIcon = leadingIcon
        self.showLeadingIcon = showLeadingIcon
        self.trailingIcon = trailingIcon
        self.showTrailingIcon = showTrailingIcon
        self.onTrailingTap = onTrailingTap
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: contentSpacing) {
            // Leading icon — 16x16
            if type.supportsIcons, showLeadingIcon, let leadingIcon {
                leadingIcon
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(type.textColor)
            }

            // Label
            Text(text)
                .adibTextStyle(ADIBTypography.caption.regular, color: type.textColor)
                .lineLimit(1)

            // Trailing icon — 16x16
            if type.supportsIcons, showTrailingIcon {
                Button {
                    onTrailingTap?()
                } label: {
                    (trailingIcon ?? Image("x"))
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize)
                        .foregroundStyle(type.textColor)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(type.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Exceed/Loyalty Tag (Special Case)

/// The content variant of the Exceed loyalty tag.
public enum ADIBExceedTagType {
    /// Shows logo + "Exceed" + chevron — no points to display
    case noPoints
    /// Shows the Exceed logo and the points balance
    case hasPoints(String)
}

/// A special tag for the Exceed loyalty program.
///
/// Uses a semi-transparent white overlay background, designed for dark/gradient surfaces.
///
/// ```swift
/// ADIBExceedTag(type: .noPoints)
/// ADIBExceedTag(type: .hasPoints("16,841.23"))
/// ```
public struct ADIBExceedTag: View {

    // MARK: - Properties

    private let type: ADIBExceedTagType
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let cornerRadius: CGFloat = ADIBSizes.Radius.small      // 12pt
    private let horizontalPadding: CGFloat = ADIBSizes.Spacing.small // 8pt
    private let verticalPadding: CGFloat = ADIBSizes.Spacing.xsmall  // 4pt
    private let iconSize: CGFloat = ADIBSizes.Spacing.medium         // 16pt

    // MARK: - Init

    public init(
        type: ADIBExceedTagType,
        onTap: (() -> Void)? = nil
    ) {
        self.type = type
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button {
            onTap?()
        } label: {
            content
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var content: some View {
        switch type {
        case .noPoints:
            HStack(spacing: ADIBSizes.Spacing.xsmall) {
                Image("Exceed")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: iconSize)
                    .foregroundStyle(ADIBColors.Text.white)

                Text("Exceed")
                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.white)
                    .lineLimit(1)

                Image("chevron-right")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(ADIBColors.Text.white)
            }

        case .hasPoints(let points):
            HStack(spacing: ADIBSizes.Spacing.small) {
                Image("Exceed")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: iconSize)
                    .foregroundStyle(ADIBColors.Text.white)

                Text(points)
                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.white)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
struct ADIBTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            ADIBTag("Label", type: .default, leadingIcon: Image(systemName: "timer"), onTrailingTap: {})
            ADIBTag("Label", type: .info, leadingIcon: Image(systemName: "timer"), onTrailingTap: {})
            ADIBTag("Label", type: .success, leadingIcon: Image(systemName: "timer"), onTrailingTap: {})
            ADIBTag("Label", type: .warning, leadingIcon: Image(systemName: "timer"), onTrailingTap: {})
            ADIBTag("Label", type: .error, leadingIcon: Image(systemName: "timer"), onTrailingTap: {})
            ADIBTag("Label", type: .selected, onTrailingTap: {})
            ADIBTag("Label", type: .unselected)
            ADIBTag("Label", type: .new)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                ADIBExceedTag(type: .noPoints)
                ADIBExceedTag(type: .hasPoints("16,841.23"))
            }
            .padding()
            .background(ADIBColors.Text.base)
            .cornerRadius(12)
        }
        .padding()
        .background(ADIBColors.background)
    }
}
#endif
