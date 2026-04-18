import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Slider Component

/// A custom-styled slider from the ADIB design system.
///
/// Wraps the native SwiftUI `Slider` with brand-primary tint color
/// and optional min/max info labels beneath the track.
///
/// ```swift
/// @State var value: Double = 50
///
/// // Basic slider
/// ADIBSlider(value: $value, range: 0...100)
///
/// // With labels
/// ADIBSlider(
///     value: $value,
///     range: 0...100,
///     minLabel: "AED 0",
///     maxLabel: "AED 100,000"
/// )
///
/// // With step
/// ADIBSlider(
///     value: $value,
///     range: 0...100,
///     step: 10,
///     minLabel: "0%",
///     maxLabel: "100%"
/// )
/// ```
public struct ADIBSlider: View {

    // MARK: - Properties

    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double?
    private let minLabel: String?
    private let maxLabel: String?

    // MARK: - Constants

    private let labelGap: CGFloat = ADIBSizes.Spacing.small                 // 8

    // MARK: - Init

    /// Creates a slider.
    /// - Parameters:
    ///   - value: Binding to the current value.
    ///   - range: The allowed range of values.
    ///   - step: Optional step increment (nil = continuous).
    ///   - minLabel: Optional label below the minimum end.
    ///   - maxLabel: Optional label below the maximum end.
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double? = nil,
        minLabel: String? = nil,
        maxLabel: String? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.minLabel = minLabel
        self.maxLabel = maxLabel
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: labelGap) {
            sliderView
                .tint(ADIBColors.interaction)
                .accentColor(ADIBColors.interaction)
                #if canImport(UIKit)
                .onAppear {
                    UISlider.appearance().maximumTrackTintColor = UIColor(ADIBColors.Surface.components)
                }
                #endif

            // Min / Max labels
            if minLabel != nil || maxLabel != nil {
                HStack {
                    if let minLabel {
                        Text(minLabel)
                            .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
                    }

                    Spacer()

                    if let maxLabel {
                        Text(maxLabel)
                            .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
                    }
                }
            }
        }
    }

    // MARK: - Slider View

    @ViewBuilder
    private var sliderView: some View {
        if let step {
            Slider(value: $value, in: range, step: step)
        } else {
            Slider(value: $value, in: range)
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Slider") {
    SliderPreview()
}

private struct SliderPreview: View {
    @State private var val1: Double = 50
    @State private var val2: Double = 25000

    var body: some View {
        VStack(spacing: ADIBSizes.Spacing.xlarge) {
            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("Basic Slider")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSlider(value: $val1, range: 0...100)
            }

            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("With Labels")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSlider(
                    value: $val2,
                    range: 0...100000,
                    minLabel: "AED 0",
                    maxLabel: "AED 100,000"
                )
            }

            VStack(spacing: ADIBSizes.Spacing.small) {
                Text("With Step")
                    .adibTextStyle(ADIBTypography.caption.semibold)
                ADIBSlider(
                    value: $val1,
                    range: 0...100,
                    step: 10,
                    minLabel: "0%",
                    maxLabel: "100%"
                )
            }
        }
        .padding()
        .background(ADIBColors.background)
    }
}
#endif
