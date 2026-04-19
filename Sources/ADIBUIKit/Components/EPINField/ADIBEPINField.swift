import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - ePIN Field Component

/// A hidden PIN entry field from the ADIB design system.
///
/// Displays a row of rounded squares that fill with dots as the user
/// types a PIN. Supports default, active, filled, and error states.
///
/// ```swift
/// // 4-digit PIN
/// ADIBEPINField(
///     pin: $pin,
///     length: 4,
///     label: "Enter your ePIN"
/// )
///
/// // Error state
/// ADIBEPINField(
///     pin: $pin,
///     length: 4,
///     label: "Enter your ePIN",
///     helperText: "Incorrect ePIN. Please try again.",
///     isError: true
/// )
/// ```
public struct ADIBEPINField: View {

    // MARK: - Properties

    @Binding private var pin: String
    private let length: Int
    private let label: String?
    private let helperText: String?
    private let isError: Bool
    private let isDisabled: Bool

    @FocusState private var isFocused: Bool

    // MARK: - Constants

    private let boxSize: CGFloat = 48
    private let boxRadius: CGFloat = ADIBSizes.Radius.medium              // 16
    private let boxGap: CGFloat = ADIBSizes.Spacing.small                 // 8
    private let dotSize: CGFloat = 10
    private let labelFieldGap: CGFloat = 12
    private let borderWidth: CGFloat = 1.5

    // MARK: - Init

    /// Creates an ePIN entry field.
    /// - Parameters:
    ///   - pin: A binding to the PIN string value.
    ///   - length: The number of PIN digits (default `4`).
    ///   - label: Optional label text above the field.
    ///   - helperText: Optional helper/error text below the field.
    ///   - isError: Whether the field is in error state (default `false`).
    ///   - isDisabled: Whether the field is disabled (default `false`).
    public init(
        pin: Binding<String>,
        length: Int = 4,
        label: String? = nil,
        helperText: String? = nil,
        isError: Bool = false,
        isDisabled: Bool = false
    ) {
        self._pin = pin
        self.length = length
        self.label = label
        self.helperText = helperText
        self.isError = isError
        self.isDisabled = isDisabled
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: labelFieldGap) {
            // Label
            if let label, !label.isEmpty {
                Text(label)
                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
            }

            // PIN boxes
            ZStack {
                // Hidden text field for keyboard input
                hiddenTextField

                // Visual boxes
                HStack(spacing: boxGap) {
                    ForEach(0..<length, id: \.self) { index in
                        pinBox(at: index)
                    }
                }
            }

            // Helper text
            if let helperText, !helperText.isEmpty {
                Text(helperText)
                    .adibTextStyle(
                        ADIBTypography.caption.regular,
                        color: isError ? ADIBColors.Semantic.Error.two : ADIBColors.Inputs.placeholder
                    )
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    // MARK: - Hidden Text Field

    private var hiddenTextField: some View {
        TextField("", text: $pin)
            .focused($isFocused)
            #if canImport(UIKit)
            .keyboardType(.numberPad)
            #endif
            .foregroundStyle(.clear)
            .tint(.clear)
            .accentColor(.clear)
            .frame(width: 1, height: 1)
            .opacity(0.01)
            .onChange(of: pin) { newValue in
                // Limit to digits and length
                let filtered = String(newValue.filter { $0.isNumber }.prefix(length))
                if filtered != newValue {
                    pin = filtered
                }
            }
            .disabled(isDisabled)
    }

    // MARK: - Pin Box

    private func pinBox(at index: Int) -> some View {
        let isFilled = index < pin.count
        let isActive = isFocused && index == pin.count
        let showError = isError && isFilled

        return ZStack {
            // Background
            RoundedRectangle(cornerRadius: boxRadius)
                .fill(ADIBColors.Surface.components)

            // Border
            if isActive || showError {
                RoundedRectangle(cornerRadius: boxRadius)
                    .stroke(
                        showError ? ADIBColors.Semantic.Error.two : ADIBColors.Text.base,
                        lineWidth: borderWidth
                    )
            }

            // Dot
            if isFilled {
                Circle()
                    .fill(showError ? ADIBColors.Semantic.Error.two : ADIBColors.Text.base)
                    .frame(width: dotSize, height: dotSize)
            }
        }
        .frame(width: boxSize, height: boxSize)
        .onTapGesture {
            isFocused = true
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("ePIN Field") {
    VStack(spacing: ADIBSizes.Spacing.xlarge) {
        // Empty
        ADIBEPINField(
            pin: .constant(""),
            label: "Enter your ePIN"
        )

        // Partially filled
        ADIBEPINField(
            pin: .constant("12"),
            label: "Enter your ePIN"
        )

        // Fully filled
        ADIBEPINField(
            pin: .constant("1234"),
            label: "Enter your ePIN"
        )

        // Error
        ADIBEPINField(
            pin: .constant("1234"),
            label: "Enter your ePIN",
            helperText: "Incorrect ePIN. Please try again.",
            isError: true
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
