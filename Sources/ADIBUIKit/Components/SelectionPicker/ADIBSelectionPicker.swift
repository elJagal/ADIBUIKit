import SwiftUI

// MARK: - Selection Picker Component

/// A segmented selection picker from the ADIB design system.
///
/// Displays 2 or 3 pill-shaped options in a rounded container.
/// The selected option uses a filled background with white text.
/// Differs from `ADIBSegmentedTabs` in visual style — uses brand primary
/// fill for the active option instead of a raised surface.
///
/// ```swift
/// @State var selected = 0
///
/// // Two options
/// ADIBSelectionPicker(
///     options: ["Yes", "No"],
///     selection: $selected
/// )
///
/// // Three options
/// ADIBSelectionPicker(
///     options: ["Daily", "Weekly", "Monthly"],
///     selection: $selected
/// )
/// ```
public struct ADIBSelectionPicker: View {

    // MARK: - Properties

    private let options: [String]
    @Binding private var selection: Int

    // MARK: - Constants

    private let containerRadius: CGFloat = ADIBSizes.Radius.medium          // 16
    private let containerPadding: CGFloat = ADIBSizes.Spacing.xsmall        // 4
    private let optionSpacing: CGFloat = ADIBSizes.Spacing.small            // 8
    private let optionHeight: CGFloat = 40
    private let optionRadius: CGFloat = ADIBSizes.Radius.small              // 12

    // MARK: - Init

    /// Creates a selection picker.
    /// - Parameters:
    ///   - options: An array of option titles (2 or 3 items).
    ///   - selection: A binding to the selected option index.
    public init(
        options: [String],
        selection: Binding<Int>
    ) {
        self.options = Array(options.prefix(3))
        self._selection = selection
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: optionSpacing) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, title in
                optionButton(title: title, index: index)
            }
        }
        .padding(containerPadding)
        .background(
            RoundedRectangle(cornerRadius: containerRadius)
                .fill(ADIBColors.Inputs.background)
        )
    }

    // MARK: - Option Button

    private func optionButton(title: String, index: Int) -> some View {
        let isActive = selection == index

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = index
            }
        } label: {
            Text(title)
                .adibTextStyle(
                    isActive ? ADIBTypography.body.semibold : ADIBTypography.body.regular,
                    color: isActive ? ADIBColors.Text.white : ADIBColors.Text.base
                )
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .frame(height: optionHeight)
                .background(
                    RoundedRectangle(cornerRadius: optionRadius)
                        .fill(isActive ? ADIBColors.Brand.Primary.one : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Selection Picker") {
    SelectionPickerPreview()
}

private struct SelectionPickerPreview: View {
    @State private var sel2 = 0
    @State private var sel3 = 1

    var body: some View {
        VStack(spacing: ADIBSizes.Spacing.xlarge) {
            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("2 Options")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSelectionPicker(options: ["Yes", "No"], selection: $sel2)
            }

            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("3 Options")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSelectionPicker(options: ["Daily", "Weekly", "Monthly"], selection: $sel3)
            }
        }
        .padding()
        .background(ADIBColors.background)
    }
}
#endif
