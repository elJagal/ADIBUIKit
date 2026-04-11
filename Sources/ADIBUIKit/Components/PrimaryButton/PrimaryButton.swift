import SwiftUI

/// A primary action button from the ADIB design system.
///
/// Supports three sizes (small, medium, large), and four states
/// (default, tapped, disabled, loading) matching the Figma spec.
public struct PrimaryButton: View {

    // MARK: - Types

    public enum Size {
        case small, medium, large

        var width: CGFloat {
            switch self {
            case .small: return 258
            case .medium: return 319
            case .large: return 386
            }
        }
    }

    // MARK: - Properties

    private let title: String
    private let size: Size
    private let isLoading: Bool
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Init

    /// Creates a primary button.
    /// - Parameters:
    ///   - title: The button label text.
    ///   - size: The button size variant (default `.large`).
    ///   - isLoading: Whether the button shows a loading indicator (default `false`).
    ///   - action: The closure to execute on tap.
    public init(
        _ title: String,
        size: Size = .large,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    LoadingDots()
                } else {
                    Text(title)
                        .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Button.Primary.text)
                }
            }
            .frame(width: size.width, height: 48)
            .foregroundStyle(ADIBColors.Button.Primary.text)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isLoading)
    }

    // MARK: - Helpers

    private var backgroundColor: Color {
        if !isEnabled {
            return ADIBColors.Button.Primary.disabled
        }
        if isLoading {
            return ADIBColors.Button.Primary.background
        }
        return ADIBColors.Button.Primary.background
    }
}

// MARK: - Button Style

private struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(pressedBackground(isPressed: configuration.isPressed))
            )
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }

    private func pressedBackground(isPressed: Bool) -> Color {
        if !isEnabled {
            return ADIBColors.Button.Primary.disabled
        }
        return isPressed
            ? ADIBColors.Button.Primary.tapped
            : Color.clear
    }
}

// MARK: - Loading Dots

private struct LoadingDots: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(ADIBColors.Button.Primary.text)
                    .frame(width: 6, height: 6)
                    .offset(y: animating ? -4 : 4)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.15),
                        value: animating
                    )
            }
        }
        .onAppear { animating = true }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("All Variants") {
    ScrollView {
        VStack(spacing: 24) {
            // Default
            Group {
                PrimaryButton("Done", size: .small) {}
                PrimaryButton("Done", size: .medium) {}
                PrimaryButton("Done", size: .large) {}
            }

            Divider()

            // Disabled
            Group {
                PrimaryButton("Done", size: .small) {}.disabled(true)
                PrimaryButton("Done", size: .medium) {}.disabled(true)
                PrimaryButton("Done", size: .large) {}.disabled(true)
            }

            Divider()

            // Loading
            Group {
                PrimaryButton("Done", size: .small, isLoading: true) {}
                PrimaryButton("Done", size: .medium, isLoading: true) {}
                PrimaryButton("Done", size: .large, isLoading: true) {}
            }
        }
        .padding()
    }
}
#endif
