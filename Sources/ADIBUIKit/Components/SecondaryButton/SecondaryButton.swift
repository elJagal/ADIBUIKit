import SwiftUI

/// A secondary (outlined) button from the ADIB design system.
///
/// Bordered button with no fill. Four states: default, tapped, disabled, loading.
/// Width: 335pt, Height: 54pt (with 16pt vertical padding), Corner radius: 16pt.
/// Border: 1pt, color changes per state.
///
/// ```swift
/// SecondaryButton("Done") { print("Tapped") }
/// SecondaryButton("Cancel") {}.disabled(true)
/// SecondaryButton("Loading", isLoading: true) {}
/// ```
public struct SecondaryButton: View {

    // MARK: - Properties

    private let title: String
    private let isLoading: Bool
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Init

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
                    ADIBLoadingDots(color: ADIBColors.Button.Secondary.text)
                } else {
                    Text(title)
                        .adibTextStyle(
                            ADIBTypography.body.semibold,
                            color: isEnabled
                                ? ADIBColors.Button.Secondary.text
                                : ADIBColors.Button.Secondary.disabled
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(ADIBSecondaryButtonStyle())
        .disabled(isLoading)
    }

    // MARK: - Helpers

    private var borderColor: Color {
        if !isEnabled { return ADIBColors.Button.Secondary.disabled }
        return ADIBColors.Button.Secondary.border
    }
}

// MARK: - Button Style

private struct ADIBSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isEnabled && configuration.isPressed
                            ? ADIBColors.Button.Secondary.tapped
                            : Color.clear,
                        lineWidth: 1
                    )
            )
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Secondary Button") {
    VStack(spacing: 16) {
        SecondaryButton("Done") {}
        SecondaryButton("Done") {}.disabled(true)
        SecondaryButton("Done", isLoading: true) {}
    }
    .adibScreenPadding()
}
#endif
