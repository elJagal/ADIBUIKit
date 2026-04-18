import SwiftUI

// MARK: - Toggle Component

/// A toggle control from the ADIB design system.
///
/// Wraps the native iOS `Toggle` with a description label on the left,
/// following the ADIB layout pattern (description + toggle, 24px gap).
///
/// ```swift
/// @State var isOn = true
///
/// ADIBToggle(isOn: $isOn, description: "Enable notifications")
/// ADIBToggle(isOn: $isOn, description: "Dark mode")
/// ```
public struct ADIBToggle: View {

    // MARK: - Properties

    @Binding private var isOn: Bool
    private let description: String

    // MARK: - Constants

    private let gap: CGFloat = ADIBSizes.Spacing.large                      // 24

    // MARK: - Init

    /// Creates a toggle control.
    /// - Parameters:
    ///   - isOn: Binding to the on/off state.
    ///   - description: The description label text.
    public init(
        isOn: Binding<Bool>,
        description: String
    ) {
        self._isOn = isOn
        self.description = description
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: gap) {
            Text(description)
                .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Toggle") {
    TogglePreview()
}

private struct TogglePreview: View {
    @State private var toggle1 = true
    @State private var toggle2 = false

    var body: some View {
        VStack(spacing: ADIBSizes.Spacing.large) {
            ADIBToggle(isOn: $toggle1, description: "Enable notifications")
            ADIBToggle(isOn: $toggle2, description: "Dark mode")
        }
        .padding()
        .background(ADIBColors.background)
    }
}
#endif
