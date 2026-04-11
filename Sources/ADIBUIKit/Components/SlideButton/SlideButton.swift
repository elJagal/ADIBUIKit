import SwiftUI

/// A slide-to-confirm button from the ADIB design system.
///
/// The user drags a thumb from left to right to confirm an action.
/// Three states: default, confirmed (green checkmark), disabled.
/// Height: 54pt, Corner radius: 16pt.
///
/// ```swift
/// SlideButton("Slide to confirm") { print("Confirmed!") }
/// SlideButton("Slide to confirm") {}.disabled(true)
/// ```
public struct SlideButton: View {

    // MARK: - Properties

    private let title: String
    private let onConfirm: () -> Void

    @State private var dragOffset: CGFloat = 0
    @State private var isConfirmed = false

    @Environment(\.isEnabled) private var isEnabled

    private let thumbSize: CGFloat = ADIBSizes.ButtonHeight.base
    private let height: CGFloat = ADIBSizes.ButtonHeight.base
    private let cornerRadius: CGFloat = ADIBSizes.Radius.medium

    // MARK: - Init

    public init(
        _ title: String = "Slide to confirm",
        onConfirm: @escaping () -> Void
    ) {
        self.title = title
        self.onConfirm = onConfirm
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            let maxOffset = geometry.size.width - thumbSize

            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ADIBColors.Surface.components)
                    .frame(height: height)

                // Label
                if !isConfirmed {
                    Text(title)
                        .adibTextStyle(
                            ADIBTypography.body.regular,
                            color: isEnabled
                                ? ADIBColors.Inputs.placeholder
                                : ADIBColors.Button.Primary.disabled
                        )
                        .frame(maxWidth: .infinity)
                }

                // Thumb or Checkmark
                if isConfirmed {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(ADIBColors.Semantic.Success.two)
                            .frame(width: thumbSize, height: thumbSize)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                    }
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isEnabled
                              ? ADIBColors.Button.Primary.background
                              : ADIBColors.Button.Primary.disabled)
                        .frame(width: thumbSize, height: thumbSize)
                        .overlay(
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                        )
                        .offset(x: dragOffset)
                        .gesture(
                            isEnabled
                            ? DragGesture(minimumDistance: 10, coordinateSpace: .local)
                                .onChanged { value in
                                    // Only respond to primarily horizontal drags
                                    guard abs(value.translation.width) > abs(value.translation.height) else { return }
                                    dragOffset = min(max(0, value.translation.width), maxOffset)
                                }
                                .onEnded { _ in
                                    if dragOffset > maxOffset * 0.7 {
                                        withAnimation(.spring(response: 0.3)) {
                                            isConfirmed = true
                                        }
                                        onConfirm()
                                    } else {
                                        withAnimation(.spring(response: 0.3)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                            : nil
                        )
                }
            }
        }
        .frame(height: height)
    }

    // MARK: - Public Reset

    /// Resets the slider to its initial state.
    public mutating func reset() {
        isConfirmed = false
        dragOffset = 0
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Slide Button") {
    VStack(spacing: 24) {
        SlideButton("Slide to confirm") { print("Confirmed!") }
        SlideButton("Slide to confirm") {}.disabled(true)
    }
    .adibScreenPadding()
}
#endif
