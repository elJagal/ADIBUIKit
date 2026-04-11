import SwiftUI

/// A primary action button from the ADIB design system.
///
/// Full-width filled button with four states: default, tapped, disabled, loading.
/// Width: 335pt, Height: 54pt, Corner radius: 16pt, Padding: 16pt vertical.
///
/// ```swift
/// PrimaryButton("Done") { print("Tapped") }
/// PrimaryButton("Submit", isLoading: true) {}
/// PrimaryButton("Continue") {}.disabled(true)
/// ```
public struct PrimaryButton: View {

    // MARK: - Properties

    private let title: String
    private let isLoading: Bool
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Init

    /// Creates a primary button.
    /// - Parameters:
    ///   - title: The button label text.
    ///   - isLoading: Whether the button shows a loading indicator (default `false`).
    ///   - action: The closure to execute on tap.
    public init(
        _ title: String,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ADIBLoadingDots(color: ADIBColors.Button.Primary.text)
                } else {
                    Text(title)
                        .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Button.Primary.text)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(ADIBPrimaryButtonStyle())
        .disabled(isLoading)
    }

    // MARK: - Helpers

    private var backgroundColor: Color {
        if !isEnabled { return ADIBColors.Button.Primary.disabled }
        return ADIBColors.Button.Primary.background
    }
}

// MARK: - Button Style

private struct ADIBPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isEnabled && configuration.isPressed
                          ? ADIBColors.Button.Primary.tapped
                          : Color.clear)
            )
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Primary Button") {
    VStack(spacing: 16) {
        PrimaryButton("Done") {}
        PrimaryButton("Done") {}.disabled(true)
        PrimaryButton("Done", isLoading: true) {}
    }
    .adibScreenPadding()
}
#endif
