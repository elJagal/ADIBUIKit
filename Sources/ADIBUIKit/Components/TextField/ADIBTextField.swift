import SwiftUI

#if canImport(UIKit)
import UIKit
#else
/// Placeholder for macOS builds where UIKeyboardType does not exist.
public enum UIKeyboardType: Int {
    case `default` = 0
    case asciiCapable = 1
    case numbersAndPunctuation = 2
    case URL = 3
    case numberPad = 4
    case phonePad = 5
    case namePhonePad = 6
    case emailAddress = 7
    case decimalPad = 8
    case twitter = 9
    case webSearch = 10
    case asciiCapableNumberPad = 11
}
#endif

// MARK: - Text Field State

/// The visual state of the text field.
public enum ADIBTextFieldState {
    /// Default resting state — no border.
    case `default`
    /// Active/focused state — border with placeholder color.
    case active
    /// Filled state — has value, no border.
    case filled
    /// Error state — red border, red helper text.
    case error
    /// Disabled state — reduced opacity.
    case disabled
}

// MARK: - Text Field Component

/// A text field component from the ADIB design system.
///
/// Supports label, placeholder, prefix (with optional dropdown chevron),
/// trailing icon, helper text, and error state.
///
/// The field state is managed automatically based on focus and validation,
/// or can be overridden via the `state` binding.
///
/// ```swift
/// // Basic text field
/// ADIBTextField(
///     label: "Full name",
///     placeholder: "Enter your name",
///     text: $name
/// )
///
/// // With prefix (phone number)
/// ADIBTextField(
///     label: "Mobile number",
///     placeholder: "5X XXX XXXX",
///     text: $phone,
///     prefix: "+971",
///     showPrefixDivider: true
/// )
///
/// // With error
/// ADIBTextField(
///     label: "Email",
///     placeholder: "Enter email",
///     text: $email,
///     helperText: "Invalid email address",
///     isError: true
/// )
///
/// // With trailing icon
/// ADIBTextField(
///     label: "Account",
///     placeholder: "Select account",
///     text: $account,
///     trailingIcon: Image("chevron-right"),
///     onTrailingIcon: { showPicker() }
/// )
///
/// // With thumbnail image
/// ADIBTextField(
///     label: "Beneficiary",
///     placeholder: "Enter name",
///     text: $name,
///     thumbnailImage: Image("avatar")
/// )
/// ```
public struct ADIBTextField: View {

    // MARK: - Properties

    private let label: String?
    private let placeholder: String
    @Binding private var text: String
    private let prefix: String?
    private let showPrefixDropdown: Bool
    private let showPrefixDivider: Bool
    private let onPrefixTap: (() -> Void)?
    private let thumbnailImage: Image?
    private let showThumbnailDropdown: Bool
    private let showThumbnailDivider: Bool
    private let trailingIcon: Image?
    private let onTrailingIcon: (() -> Void)?
    private let helperText: String?
    private let isError: Bool
    private let isDisabled: Bool
    private let keyboardType: UIKeyboardType

    @FocusState private var isFocused: Bool

    // MARK: - Constants

    private let fieldHeight: CGFloat = 48
    private let fieldRadius: CGFloat = ADIBSizes.Radius.medium            // 16
    private let horizontalPadding: CGFloat = ADIBSizes.Spacing.medium     // 16
    private let labelFieldGap: CGFloat = 12
    private let fieldHelperGap: CGFloat = 12
    private let prefixContentGap: CGFloat = 12
    private let prefixChevronGap: CGFloat = ADIBSizes.Spacing.xsmall     // 4
    private let iconSize: CGFloat = ADIBSizes.Spacing.large               // 24
    private let thumbnailSize: CGFloat = ADIBSizes.Spacing.large          // 24

    // MARK: - Init

    /// Creates an ADIB text field.
    /// - Parameters:
    ///   - label: Optional label text above the field.
    ///   - placeholder: Placeholder text shown when empty.
    ///   - text: A binding to the text value.
    ///   - prefix: Optional prefix text (e.g. "+971").
    ///   - showPrefixDropdown: Whether to show a chevron-down next to the prefix (default `false`).
    ///   - showPrefixDivider: Whether to show a vertical divider after the prefix (default `true` when prefix is set).
    ///   - onPrefixTap: Action when the prefix area is tapped.
    ///   - thumbnailImage: Optional circular thumbnail image on the left (24×24).
    ///   - showThumbnailDropdown: Whether to show a chevron-down next to the thumbnail (default `false`).
    ///   - showThumbnailDivider: Whether to show a vertical divider after the thumbnail (default `true`).
    ///   - trailingIcon: Optional trailing icon on the right side.
    ///   - onTrailingIcon: Action when the trailing icon is tapped.
    ///   - helperText: Optional helper/hint text below the field.
    ///   - isError: Whether the field is in error state (default `false`).
    ///   - isDisabled: Whether the field is disabled (default `false`).
    ///   - keyboardType: The keyboard type for the text field (default `.default`).
    public init(
        label: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        prefix: String? = nil,
        showPrefixDropdown: Bool = false,
        showPrefixDivider: Bool = true,
        onPrefixTap: (() -> Void)? = nil,
        thumbnailImage: Image? = nil,
        showThumbnailDropdown: Bool = false,
        showThumbnailDivider: Bool = true,
        trailingIcon: Image? = nil,
        onTrailingIcon: (() -> Void)? = nil,
        helperText: String? = nil,
        isError: Bool = false,
        isDisabled: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.prefix = prefix
        self.showPrefixDropdown = showPrefixDropdown
        self.showPrefixDivider = showPrefixDivider
        self.onPrefixTap = onPrefixTap
        self.thumbnailImage = thumbnailImage
        self.showThumbnailDropdown = showThumbnailDropdown
        self.showThumbnailDivider = showThumbnailDivider
        self.trailingIcon = trailingIcon
        self.onTrailingIcon = onTrailingIcon
        self.helperText = helperText
        self.isError = isError
        self.isDisabled = isDisabled
        self.keyboardType = keyboardType
    }

    // MARK: - Computed State

    private var currentState: ADIBTextFieldState {
        if isDisabled { return .disabled }
        if isError { return .error }
        if isFocused { return .active }
        if !text.isEmpty { return .filled }
        return .default
    }

    private var borderColor: Color {
        switch currentState {
        case .active:
            return ADIBColors.Inputs.placeholder
        case .error:
            return ADIBColors.Semantic.Error.two
        default:
            return .clear
        }
    }

    private var showBorder: Bool {
        currentState == .active || currentState == .error
    }

    private var helperTextColor: Color {
        switch currentState {
        case .error:
            return ADIBColors.Semantic.Error.two
        case .filled, .active:
            return ADIBColors.Text.subdued
        default:
            return ADIBColors.Inputs.placeholder
        }
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: labelFieldGap) {

            // Label
            if let label, !label.isEmpty {
                Text(label)
                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
            }

            // Input field container
            HStack(spacing: 0) {

                // Prefix
                if let prefix, !prefix.isEmpty {
                    prefixView(prefix)
                }

                // Thumbnail
                if let thumbnailImage {
                    thumbnailView(thumbnailImage)
                }

                // Text input
                TextField(placeholder, text: $text)
                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
                    #if canImport(UIKit)
                    .keyboardType(keyboardType)
                    #endif
                    .focused($isFocused)
                    .disabled(isDisabled)

                // Trailing icon
                if let trailingIcon {
                    trailingIconView(trailingIcon)
                }
            }
            .frame(height: fieldHeight)
            .padding(.horizontal, horizontalPadding)
            .background(
                RoundedRectangle(cornerRadius: fieldRadius)
                    .fill(ADIBColors.Surface.components)
            )
            .overlay(
                RoundedRectangle(cornerRadius: fieldRadius)
                    .stroke(borderColor, lineWidth: showBorder ? 1 : 0)
            )

            // Helper text
            if let helperText, !helperText.isEmpty {
                Text(helperText)
                    .adibTextStyle(ADIBTypography.caption.regular, color: helperTextColor)
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    // MARK: - Prefix View

    private func prefixView(_ prefix: String) -> some View {
        HStack(spacing: prefixContentGap) {
            Button {
                onPrefixTap?()
            } label: {
                HStack(spacing: prefixChevronGap) {
                    Text(prefix)
                        .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Inputs.placeholder)

                    if showPrefixDropdown {
                        Image("chevron-down", bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .foregroundStyle(ADIBColors.Inputs.placeholder)
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(onPrefixTap == nil)

            if showPrefixDivider {
                Rectangle()
                    .fill(ADIBColors.border)
                    .frame(width: 1, height: fieldHeight)
            }
        }
        .padding(.trailing, prefixContentGap)
    }

    // MARK: - Thumbnail View

    private func thumbnailView(_ image: Image) -> some View {
        HStack(spacing: prefixContentGap) {
            HStack(spacing: prefixChevronGap) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: thumbnailSize, height: thumbnailSize)
                    .clipShape(Circle())

                if showThumbnailDropdown {
                    Image("chevron-down", bundle: .module)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .foregroundStyle(ADIBColors.Inputs.placeholder)
                }
            }

            if showThumbnailDivider {
                Rectangle()
                    .fill(ADIBColors.border)
                    .frame(width: 1, height: fieldHeight)
            }
        }
        .padding(.trailing, prefixContentGap)
    }

    // MARK: - Trailing Icon View

    private func trailingIconView(_ icon: Image) -> some View {
        Button {
            onTrailingIcon?()
        } label: {
            icon
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(ADIBColors.Inputs.placeholder)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(onTrailingIcon == nil)
        .padding(.leading, ADIBSizes.Spacing.small)
    }
}

// MARK: - Selector / Dropdown Field

/// A non-editable text field that acts as a selector/dropdown trigger.
///
/// Looks identical to `ADIBTextField` but taps open a picker/sheet
/// instead of showing the keyboard.
///
/// ```swift
/// ADIBSelectorField(
///     label: "Currency",
///     placeholder: "Select currency",
///     value: selectedCurrency,
///     trailingIcon: Image("chevron-right"),
///     onTap: { showCurrencyPicker = true }
/// )
/// ```
public struct ADIBSelectorField: View {

    // MARK: - Properties

    private let label: String?
    private let placeholder: String
    private let value: String?
    private let prefix: String?
    private let showPrefixDropdown: Bool
    private let showPrefixDivider: Bool
    private let thumbnailImage: Image?
    private let showThumbnailDropdown: Bool
    private let showThumbnailDivider: Bool
    private let trailingIcon: Image?
    private let helperText: String?
    private let isError: Bool
    private let isDisabled: Bool
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let fieldHeight: CGFloat = 48
    private let fieldRadius: CGFloat = ADIBSizes.Radius.medium
    private let horizontalPadding: CGFloat = ADIBSizes.Spacing.medium
    private let labelFieldGap: CGFloat = 12
    private let prefixContentGap: CGFloat = 12
    private let iconSize: CGFloat = ADIBSizes.Spacing.large
    private let thumbnailSize: CGFloat = ADIBSizes.Spacing.large          // 24
    private let prefixChevronGap: CGFloat = ADIBSizes.Spacing.xsmall      // 4

    // MARK: - Init

    /// Creates a selector field.
    /// - Parameters:
    ///   - label: Optional label text above the field.
    ///   - placeholder: Placeholder text shown when no value is selected.
    ///   - value: The currently selected value string, or nil.
    ///   - prefix: Optional prefix text.
    ///   - showPrefixDropdown: Whether to show a chevron-down next to the prefix (default `false`).
    ///   - showPrefixDivider: Whether to show a vertical divider after the prefix.
    ///   - thumbnailImage: Optional circular thumbnail image on the left (24×24).
    ///   - showThumbnailDropdown: Whether to show a chevron-down next to the thumbnail (default `false`).
    ///   - showThumbnailDivider: Whether to show a vertical divider after the thumbnail (default `true`).
    ///   - trailingIcon: Optional trailing icon (defaults to chevron-right).
    ///   - helperText: Optional helper text below the field.
    ///   - isError: Whether the field is in error state.
    ///   - isDisabled: Whether the field is disabled.
    ///   - onTap: Action when the field is tapped.
    public init(
        label: String? = nil,
        placeholder: String = "",
        value: String? = nil,
        prefix: String? = nil,
        showPrefixDropdown: Bool = false,
        showPrefixDivider: Bool = true,
        thumbnailImage: Image? = nil,
        showThumbnailDropdown: Bool = false,
        showThumbnailDivider: Bool = true,
        trailingIcon: Image? = nil,
        helperText: String? = nil,
        isError: Bool = false,
        isDisabled: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self.value = value
        self.prefix = prefix
        self.showPrefixDropdown = showPrefixDropdown
        self.showPrefixDivider = showPrefixDivider
        self.thumbnailImage = thumbnailImage
        self.showThumbnailDropdown = showThumbnailDropdown
        self.showThumbnailDivider = showThumbnailDivider
        self.trailingIcon = trailingIcon
        self.helperText = helperText
        self.isError = isError
        self.isDisabled = isDisabled
        self.onTap = onTap
    }

    private var hasValue: Bool {
        if let value, !value.isEmpty { return true }
        return false
    }

    private var helperTextColor: Color {
        if isError { return ADIBColors.Semantic.Error.two }
        if hasValue { return ADIBColors.Text.subdued }
        return ADIBColors.Inputs.placeholder
    }

    private var borderColor: Color {
        isError ? ADIBColors.Semantic.Error.two : .clear
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: labelFieldGap) {

            // Label
            if let label, !label.isEmpty {
                Text(label)
                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
            }

            // Tappable field
            Button {
                onTap?()
            } label: {
                HStack(spacing: 0) {

                    // Prefix
                    if let prefix, !prefix.isEmpty {
                        HStack(spacing: prefixContentGap) {
                            HStack(spacing: prefixChevronGap) {
                                Text(prefix)
                                    .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Inputs.placeholder)

                                if showPrefixDropdown {
                                    Image("chevron-down", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(ADIBColors.Inputs.placeholder)
                                }
                            }

                            if showPrefixDivider {
                                Rectangle()
                                    .fill(ADIBColors.border)
                                    .frame(width: 1, height: fieldHeight)
                            }
                        }
                        .padding(.trailing, prefixContentGap)
                    }

                    // Thumbnail
                    if let thumbnailImage {
                        HStack(spacing: prefixContentGap) {
                            HStack(spacing: prefixChevronGap) {
                                thumbnailImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: thumbnailSize, height: thumbnailSize)
                                    .clipShape(Circle())

                                if showThumbnailDropdown {
                                    Image("chevron-down", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(ADIBColors.Inputs.placeholder)
                                }
                            }

                            if showThumbnailDivider {
                                Rectangle()
                                    .fill(ADIBColors.border)
                                    .frame(width: 1, height: fieldHeight)
                            }
                        }
                        .padding(.trailing, prefixContentGap)
                    }

                    // Value or placeholder
                    if let value, !value.isEmpty {
                        Text(value)
                            .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
                    } else {
                        Text(placeholder)
                            .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Inputs.placeholder)
                    }

                    Spacer(minLength: 0)

                    // Trailing icon
                    if let trailingIcon {
                        trailingIcon
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .foregroundStyle(ADIBColors.Inputs.placeholder)
                    }
                }
                .frame(height: fieldHeight)
                .padding(.horizontal, horizontalPadding)
                .background(
                    RoundedRectangle(cornerRadius: fieldRadius)
                        .fill(ADIBColors.Surface.components)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: fieldRadius)
                        .stroke(borderColor, lineWidth: isError ? 1 : 0)
                )
            }
            .buttonStyle(.plain)
            .disabled(isDisabled)

            // Helper text
            if let helperText, !helperText.isEmpty {
                Text(helperText)
                    .adibTextStyle(ADIBTypography.caption.regular, color: helperTextColor)
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Text Field — Default") {
    ScrollView {
        VStack(spacing: ADIBSizes.Spacing.xlarge) {
            ADIBTextField(
                label: "Full name",
                placeholder: "Enter your full name",
                text: .constant("")
            )

            ADIBTextField(
                label: "Full name",
                placeholder: "Enter your full name",
                text: .constant("Ahmed Mohamed")
            )

            ADIBTextField(
                label: "Email",
                placeholder: "Enter your email",
                text: .constant("ahmed@"),
                helperText: "Please enter a valid email address",
                isError: true
            )

            ADIBTextField(
                label: "Mobile number",
                placeholder: "5X XXX XXXX",
                text: .constant(""),
                prefix: "+971",
                showPrefixDropdown: true,
                helperText: "We'll send you a verification code"
            )

            ADIBTextField(
                label: "Mobile number",
                placeholder: "5X XXX XXXX",
                text: .constant("50 123 4567"),
                prefix: "+971"
            )

            ADIBTextField(
                label: "Disabled field",
                placeholder: "Cannot edit",
                text: .constant(""),
                isDisabled: true
            )
        }
        .padding(.horizontal, ADIBSizes.Spacing.medium)
        .padding(.vertical, ADIBSizes.Spacing.large)
    }
    .background(ADIBColors.background)
}

#Preview("Selector Field") {
    VStack(spacing: ADIBSizes.Spacing.xlarge) {
        ADIBSelectorField(
            label: "Account",
            placeholder: "Select account",
            trailingIcon: Image(systemName: "chevron.right"),
            onTap: {}
        )

        ADIBSelectorField(
            label: "Currency",
            placeholder: "Select currency",
            value: "AED - UAE Dirham",
            trailingIcon: Image(systemName: "chevron.right"),
            onTap: {}
        )

        ADIBSelectorField(
            label: "Phone",
            placeholder: "Enter number",
            prefix: "+971",
            trailingIcon: Image(systemName: "chevron.right"),
            helperText: "Select your country code",
            onTap: {}
        )
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .padding(.vertical, ADIBSizes.Spacing.large)
    .background(ADIBColors.background)
}
#endif
