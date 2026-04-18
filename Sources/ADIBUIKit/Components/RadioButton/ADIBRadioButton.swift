import SwiftUI

// MARK: - Radio Button Component

/// A radio button control from the ADIB design system.
///
/// Displays a circular radio indicator with optional heading and description text.
/// Supports selected/unselected states with animation.
///
/// ```swift
/// // Without heading
/// ADIBRadioButton(
///     isSelected: $selected,
///     description: "Option A"
/// )
///
/// // With heading
/// ADIBRadioButton(
///     isSelected: $selected,
///     heading: "Option Title",
///     description: "Option description text"
/// )
/// ```
public struct ADIBRadioButton: View {

    // MARK: - Properties

    @Binding private var isSelected: Bool
    private let heading: String?
    private let description: String

    // MARK: - Constants

    private let circleSize: CGFloat = 24
    private let borderWidth: CGFloat = 2
    private let innerDotSize: CGFloat = 12
    private let gap: CGFloat = 12

    // MARK: - Init

    /// Creates a radio button.
    /// - Parameters:
    ///   - isSelected: Binding to the selected state.
    ///   - heading: Optional heading text above the description.
    ///   - description: The description/label text.
    public init(
        isSelected: Binding<Bool>,
        heading: String? = nil,
        description: String
    ) {
        self._isSelected = isSelected
        self.heading = heading
        self.description = description
    }

    // MARK: - Body

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                isSelected.toggle()
            }
        } label: {
            HStack(alignment: .top, spacing: gap) {
                // Radio circle
                radioCircle
                    .padding(.top, heading != nil ? 2 : 0)

                // Text content
                VStack(alignment: .leading, spacing: ADIBSizes.Spacing.xsmall) {
                    if let heading, !heading.isEmpty {
                        Text(heading)
                            .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                            .lineLimit(1)
                    }

                    Text(description)
                        .adibTextStyle(
                            ADIBTypography.body.regular,
                            color: heading != nil ? ADIBColors.Text.subdued : ADIBColors.Text.base
                        )
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Radio Circle

    private var radioCircle: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected ? ADIBColors.Brand.Primary.one : ADIBColors.Text.subdued,
                    lineWidth: borderWidth
                )
                .frame(width: circleSize, height: circleSize)

            if isSelected {
                Circle()
                    .fill(ADIBColors.Brand.Primary.one)
                    .frame(width: innerDotSize, height: innerDotSize)
                    .transition(.scale)
            }
        }
        .frame(width: circleSize, height: circleSize)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Radio Button") {
    RadioButtonPreview()
}

private struct RadioButtonPreview: View {
    @State private var option1 = true
    @State private var option2 = false
    @State private var option3 = true
    @State private var option4 = false

    var body: some View {
        VStack(alignment: .leading, spacing: ADIBSizes.Spacing.large) {
            Text("Without Heading")
                .adibTextStyle(ADIBTypography.caption.semibold)

            ADIBRadioButton(isSelected: $option1, description: "Selected option")
            ADIBRadioButton(isSelected: $option2, description: "Unselected option")

            Divider()

            Text("With Heading")
                .adibTextStyle(ADIBTypography.caption.semibold)

            ADIBRadioButton(
                isSelected: $option3,
                heading: "Option Title",
                description: "This is a description for the option"
            )
            ADIBRadioButton(
                isSelected: $option4,
                heading: "Another Option",
                description: "Another description for this option"
            )
        }
        .padding()
        .background(ADIBColors.background)
    }
}
#endif
