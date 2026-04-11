import SwiftUI

/// A segmented pill-style tab control from the ADIB design system.
///
/// Displays 2 or 3 text tabs in a rounded container. One tab is active at a time.
/// Active tab has a white raised background; inactive tabs are flat.
///
/// ```swift
/// @State var selected = 0
///
/// // Two tabs
/// ADIBSegmentedTabs(
///     tabs: ["ADIB", "Other Banks"],
///     selection: $selected
/// )
///
/// // Three tabs
/// ADIBSegmentedTabs(
///     tabs: ["All", "Income", "Expenses"],
///     selection: $selected
/// )
/// ```
public struct ADIBSegmentedTabs: View {

    // MARK: - Properties

    private let tabs: [String]
    @Binding private var selection: Int

    // MARK: - Constants

    private let containerRadius: CGFloat = ADIBSizes.Radius.small       // 12
    private let containerPadding: CGFloat = ADIBSizes.Spacing.xxsmall   // 2
    private let tabSpacing: CGFloat = ADIBSizes.Spacing.small           // 8
    private let tabHeight: CGFloat = ADIBSizes.Spacing.xlarge           // 32
    private let tabRadius: CGFloat = ADIBSizes.Radius.small             // 12
    private let tabVerticalPadding: CGFloat = ADIBSizes.Spacing.small   // 8

    // MARK: - Init

    /// Creates a segmented tab control.
    /// - Parameters:
    ///   - tabs: An array of tab titles (2 or 3 items).
    ///   - selection: A binding to the selected tab index.
    public init(
        tabs: [String],
        selection: Binding<Int>
    ) {
        self.tabs = Array(tabs.prefix(3))
        self._selection = selection
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: tabSpacing) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, title in
                tabButton(title: title, index: index)
            }
        }
        .padding(containerPadding)
        .background(
            RoundedRectangle(cornerRadius: containerRadius)
                .fill(ADIBColors.Surface.components)
        )
    }

    // MARK: - Tab Button

    private func tabButton(title: String, index: Int) -> some View {
        let isActive = selection == index

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = index
            }
        } label: {
            Text(title)
                .font(.system(
                    size: ADIBSizes.Font.two,
                    weight: isActive ? .semibold : .regular
                ))
                .tracking(-0.15)
                .lineLimit(1)
                .foregroundStyle(
                    isActive
                        ? ADIBColors.Text.base
                        : ADIBColors.Text.subdued
                )
                .frame(maxWidth: .infinity)
                .frame(height: tabHeight)
                .background(
                    RoundedRectangle(cornerRadius: tabRadius)
                        .fill(isActive ? ADIBColors.Surface.raised : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Segmented Tabs") {
    VStack(spacing: 32) {
        SegmentedPreview2()
        SegmentedPreview3()
    }
    .adibScreenPadding()
    .background(ADIBColors.background)
}

private struct SegmentedPreview2: View {
    @State private var selected = 0
    var body: some View {
        VStack(spacing: 16) {
            Text("2 Tabs").adibTextStyle(ADIBTypography.caption.semibold)
            ADIBSegmentedTabs(tabs: ["ADIB", "Other Banks"], selection: $selected)
            Text("Selected: \(selected)")
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
        }
    }
}

private struct SegmentedPreview3: View {
    @State private var selected = 0
    var body: some View {
        VStack(spacing: 16) {
            Text("3 Tabs").adibTextStyle(ADIBTypography.caption.semibold)
            ADIBSegmentedTabs(tabs: ["All", "Income", "Expenses"], selection: $selected)
            Text("Selected: \(selected)")
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
        }
    }
}
#endif
