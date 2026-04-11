import SwiftUI

/// A tertiary (text + optional icon) button from the ADIB design system.
///
/// No background, no border. Three states: default, tapped (60% opacity), disabled (20% opacity).
/// Height: 56pt, Corner radius: 16pt.
///
/// ```swift
/// TertiaryButton("Done") {}
/// TertiaryButton("Add", icon: Image(systemName: "plus.circle.fill")) {}
/// TertiaryButton("Done") {}.disabled(true)
/// ```
public struct TertiaryButton: View {

    // MARK: - Properties

    private let title: String
    private let icon: Image?
    private let showIcon: Bool
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Init

    public init(
        _ title: String,
        icon: Image? = Image(systemName: "plus.circle.fill"),
        showIcon: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.showIcon = showIcon
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            HStack(spacing: ADIBSizes.Spacing.small) {
                if showIcon, let icon {
                    icon
                        .resizable()
                        .frame(width: 24, height: 24)
                }

                Text(title)
                    .adibTextStyle(ADIBTypography.body.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: ADIBSizes.ButtonHeight.tertiary)
            .clipShape(RoundedRectangle(cornerRadius: ADIBSizes.Radius.medium))
        }
        .buttonStyle(ADIBTertiaryButtonStyle())
    }
}

// MARK: - Button Style

private struct ADIBTertiaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor(isPressed: configuration.isPressed))
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }

    private func foregroundColor(isPressed: Bool) -> Color {
        if !isEnabled { return ADIBColors.Button.Tertiary.disabled }
        if isPressed { return ADIBColors.Button.Tertiary.tapped }
        return ADIBColors.Button.Tertiary.default
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Tertiary Button") {
    VStack(spacing: 16) {
        TertiaryButton("Done") {}
        TertiaryButton("Done") {}.disabled(true)
        TertiaryButton("Done", showIcon: false) {}
    }
    .adibScreenPadding()
}
#endif
