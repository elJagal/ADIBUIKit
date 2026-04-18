import SwiftUI

// MARK: - Search Bar Component

/// A search bar component from the ADIB design system.
///
/// Displays a compact search input with a leading search icon.
/// When the user starts typing, a trailing "Cancel" button appears
/// that clears the text and dismisses the keyboard.
///
/// ```swift
/// // Basic usage
/// ADIBSearchBar(
///     text: $searchText,
///     placeholder: "Search"
/// )
///
/// // Custom placeholder + cancel label
/// ADIBSearchBar(
///     text: $searchText,
///     placeholder: "Search transactions",
///     cancelLabel: "Clear"
/// )
/// ```
public struct ADIBSearchBar: View {

    // MARK: - Properties

    @Binding private var text: String
    private let placeholder: String
    private let cancelLabel: String
    private let searchIcon: Image?
    private let onCancel: (() -> Void)?

    @FocusState private var isFocused: Bool

    // MARK: - Constants

    private let barHeight: CGFloat = 36
    private let barRadius: CGFloat = ADIBSizes.Radius.small               // 12
    private let iconSize: CGFloat = 16
    private let iconLeading: CGFloat = 12
    private let textLeading: CGFloat = ADIBSizes.Spacing.small            // 8
    private let cancelLeading: CGFloat = ADIBSizes.Spacing.medium         // 16

    // MARK: - Init

    /// Creates a search bar.
    /// - Parameters:
    ///   - text: A binding to the search text.
    ///   - placeholder: Placeholder text (default "Search").
    ///   - cancelLabel: The cancel button label (default "Cancel").
    ///   - searchIcon: Optional custom search icon. Falls back to the bundled search icon.
    ///   - onCancel: Optional extra action when cancel is tapped (text is cleared automatically).
    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        cancelLabel: String = "Cancel",
        searchIcon: Image? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.cancelLabel = cancelLabel
        self.searchIcon = searchIcon
        self.onCancel = onCancel
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 0) {
            // Search input field
            HStack(spacing: textLeading) {
                // Search icon
                (searchIcon ?? Image(systemName: "magnifyingglass"))
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(ADIBColors.Inputs.placeholder)

                // Text field
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Inputs.placeholder)
                    }
                    TextField("", text: $text)
                        .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)
                        .focused($isFocused)
                        #if canImport(UIKit)
                        .autocorrectionDisabled()
                        #endif
                }
            }
            .padding(.horizontal, iconLeading)
            .frame(height: barHeight)
            .background(
                RoundedRectangle(cornerRadius: barRadius)
                    .fill(ADIBColors.Surface.components)
            )

            // Cancel button — appears when text is not empty
            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused = false
                    onCancel?()
                } label: {
                    Text(cancelLabel)
                        .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.interaction)
                        .lineLimit(1)
                }
                .buttonStyle(.plain)
                .padding(.leading, cancelLeading)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Search Bar") {
    VStack(spacing: ADIBSizes.Spacing.large) {
        // Empty
        ADIBSearchBar(text: .constant(""))

        // Filled
        ADIBSearchBar(text: .constant("Text here"))
    }
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
