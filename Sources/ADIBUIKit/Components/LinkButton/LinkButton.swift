import SwiftUI

/// A link-style button from the ADIB design system.
///
/// Inline text + optional icon, no background or border.
/// Two states: default, tapped (60% opacity).
///
/// ```swift
/// LinkButton("Done") {}
/// LinkButton("Add", icon: Image(systemName: "plus.circle.fill")) {}
/// ```
public struct LinkButton: View {

    // MARK: - Properties

    private let title: String
    private let icon: Image?
    private let showIcon: Bool
    private let action: () -> Void

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
            HStack(spacing: 8) {
                if showIcon, let icon {
                    icon
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(ADIBColors.interaction)
                }

                Text(title)
                    .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.interaction)
            }
        }
        .buttonStyle(ADIBLinkButtonStyle())
    }
}

// MARK: - Button Style

private struct ADIBLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Link Button") {
    VStack(spacing: 24) {
        LinkButton("Done") {}
        LinkButton("Add", showIcon: false) {}
    }
    .adibScreenPadding()
}
#endif
