import SwiftUI

// MARK: - Selector Component

/// An individual selector option button from the ADIB design system.
///
/// A bordered pill button used for option selection. Has two visual states:
/// - **Selected (filled):** `Button.Small.background` fill with `Button.Small.text` semibold text.
/// - **Unselected (outline):** `border` stroke with `Text.base` regular text.
///
/// Typically used inside an `ADIBSelectorGrid` for multi-option selection.
///
/// ```swift
/// ADIBSelector(label: "Transfer", isSelected: true) { }
/// ADIBSelector(label: "Payment", isSelected: false) { }
/// ```
public struct ADIBSelector: View {

    // MARK: - Properties

    private let label: String
    private let isSelected: Bool
    private let action: () -> Void

    // MARK: - Constants

    private let height: CGFloat = 48
    private let radius: CGFloat = ADIBSizes.Radius.small                    // 12
    private let borderWidth: CGFloat = 1

    // MARK: - Init

    /// Creates a selector button.
    /// - Parameters:
    ///   - label: The selector label text.
    ///   - isSelected: Whether this selector is currently selected.
    ///   - action: The action to perform when tapped.
    public init(
        label: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.isSelected = isSelected
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            Text(label)
                .adibTextStyle(
                    isSelected ? ADIBTypography.body.semibold : ADIBTypography.body.regular,
                    color: isSelected ? ADIBColors.Button.Small.text : ADIBColors.Text.base
                )
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(
                    RoundedRectangle(cornerRadius: radius)
                        .fill(isSelected ? ADIBColors.Button.Small.background : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(
                            isSelected ? Color.clear : ADIBColors.border,
                            lineWidth: borderWidth
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Selector Grid Component

/// A grid layout of selector options from the ADIB design system.
///
/// Arranges 2, 3, or 4 `ADIBSelector` buttons in a responsive grid.
/// - 2 options: single row.
/// - 3 options: 2 + 1 rows.
/// - 4 options: 2 + 2 rows.
///
/// ```swift
/// @State var selected = 0
///
/// // 2 options
/// ADIBSelectorGrid(
///     options: ["Transfer", "Payment"],
///     selection: $selected
/// )
///
/// // 4 options
/// ADIBSelectorGrid(
///     options: ["Daily", "Weekly", "Monthly", "Yearly"],
///     selection: $selected
/// )
/// ```
public struct ADIBSelectorGrid: View {

    // MARK: - Properties

    private let options: [String]
    @Binding private var selection: Int

    // MARK: - Constants

    private let horizontalGap: CGFloat = 15
    private let verticalGap: CGFloat = ADIBSizes.Spacing.medium             // 16

    // MARK: - Init

    /// Creates a selector grid.
    /// - Parameters:
    ///   - options: An array of option labels (2–4 items).
    ///   - selection: A binding to the selected option index.
    public init(
        options: [String],
        selection: Binding<Int>
    ) {
        self.options = Array(options.prefix(4))
        self._selection = selection
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: verticalGap) {
            // First row — always 2 items (or 1 if only 1 exists)
            HStack(spacing: horizontalGap) {
                ForEach(Array(options.prefix(2).enumerated()), id: \.offset) { index, label in
                    ADIBSelector(
                        label: label,
                        isSelected: selection == index
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = index
                        }
                    }
                }
            }

            // Second row — items 3 and 4
            if options.count > 2 {
                HStack(spacing: horizontalGap) {
                    ForEach(Array(options.dropFirst(2).enumerated()), id: \.offset) { offset, label in
                        ADIBSelector(
                            label: label,
                            isSelected: selection == offset + 2
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selection = offset + 2
                            }
                        }
                    }

                    // Spacer for 3 options — keeps first item same width as top row
                    if options.count == 3 {
                        Color.clear
                            .frame(height: 48)
                    }
                }
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Selectors") {
    SelectorPreview()
}

private struct SelectorPreview: View {
    @State private var sel2 = 0
    @State private var sel3 = 1
    @State private var sel4 = 0

    var body: some View {
        VStack(spacing: ADIBSizes.Spacing.xlarge) {
            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("2 Selectors")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSelectorGrid(options: ["Transfer", "Payment"], selection: $sel2)
            }

            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("3 Selectors")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSelectorGrid(options: ["Daily", "Weekly", "Monthly"], selection: $sel3)
            }

            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("4 Selectors")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSelectorGrid(
                    options: ["Transfer", "Payment", "Top Up", "Donate"],
                    selection: $sel4
                )
            }
        }
        .padding()
        .background(ADIBColors.background)
    }
}
#endif
