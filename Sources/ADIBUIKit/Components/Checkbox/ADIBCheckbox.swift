import SwiftUI

// MARK: - Checkbox Component

/// A checkbox control from the ADIB design system.
///
/// Displays a rounded square checkbox with optional heading and description text.
/// When checked, shows a filled background with a checkmark icon.
///
/// ```swift
/// // Without heading
/// ADIBCheckbox(
///     isChecked: $checked,
///     description: "I agree to the terms"
/// )
///
/// // With heading
/// ADIBCheckbox(
///     isChecked: $checked,
///     heading: "Terms & Conditions",
///     description: "Please read and accept the terms"
/// )
/// ```
public struct ADIBCheckbox: View {

    // MARK: - Properties

    @Binding private var isChecked: Bool
    private let heading: String?
    private let description: String

    // MARK: - Constants

    private let boxSize: CGFloat = 24
    private let borderWidth: CGFloat = 2
    private let boxRadius: CGFloat = 5
    private let checkmarkSize: CGFloat = 14
    private let gap: CGFloat = 12

    // MARK: - Init

    /// Creates a checkbox.
    /// - Parameters:
    ///   - isChecked: Binding to the checked state.
    ///   - heading: Optional heading text above the description.
    ///   - description: The description/label text.
    public init(
        isChecked: Binding<Bool>,
        heading: String? = nil,
        description: String
    ) {
        self._isChecked = isChecked
        self.heading = heading
        self.description = description
    }

    // MARK: - Body

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                isChecked.toggle()
            }
        } label: {
            HStack(alignment: .top, spacing: gap) {
                // Checkbox
                checkboxView
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

    // MARK: - Checkbox View

    private var checkboxView: some View {
        ZStack {
            if isChecked {
                RoundedRectangle(cornerRadius: boxRadius)
                    .fill(ADIBColors.interaction)
                    .frame(width: boxSize, height: boxSize)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: checkmarkSize, weight: .bold))
                            .foregroundStyle(ADIBColors.Text.white)
                    )
                    .transition(.scale)
            } else {
                RoundedRectangle(cornerRadius: boxRadius)
                    .stroke(ADIBColors.Text.subdued, lineWidth: borderWidth)
                    .frame(width: boxSize, height: boxSize)
            }
        }
        .frame(width: boxSize, height: boxSize)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Checkbox") {
    CheckboxPreview()
}

private struct CheckboxPreview: View {
    @State private var check1 = true
    @State private var check2 = false
    @State private var check3 = true
    @State private var check4 = false

    var body: some View {
        VStack(alignment: .leading, spacing: ADIBSizes.Spacing.large) {
            Text("Without Heading")
                .adibTextStyle(ADIBTypography.caption.semibold)

            ADIBCheckbox(isChecked: $check1, description: "Checked option")
            ADIBCheckbox(isChecked: $check2, description: "Unchecked option")

            Divider()

            Text("With Heading")
                .adibTextStyle(ADIBTypography.caption.semibold)

            ADIBCheckbox(
                isChecked: $check3,
                heading: "Terms & Conditions",
                description: "I agree to the terms and conditions"
            )
            ADIBCheckbox(
                isChecked: $check4,
                heading: "Newsletter",
                description: "Subscribe to our newsletter"
            )
        }
        .padding()
        .background(ADIBColors.background)
    }
}
#endif
