import SwiftUI

/// A tab item model for the ADIB tab strip.
///
/// Each item has a title, an inactive icon, and an optional active icon.
/// If no active icon is provided, the inactive icon is used for both states.
public struct ADIBTabsItem: Identifiable, Hashable {

    public let id: String
    public let title: String
    public let icon: Image
    public let activeIcon: Image?

    /// Creates a tab strip item.
    /// - Parameters:
    ///   - id: Unique identifier for the tab.
    ///   - title: The label displayed below the icon.
    ///   - icon: The icon shown when the tab is inactive.
    ///   - activeIcon: The icon shown when the tab is active. Defaults to `icon` if nil.
    public init(
        id: String,
        title: String,
        icon: Image,
        activeIcon: Image? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.activeIcon = activeIcon
    }

    public static func == (lhs: ADIBTabsItem, rhs: ADIBTabsItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// A horizontal tab strip from the ADIB design system.
///
/// Displays a row of icon + label tabs with an active indicator line.
/// Active tab uses interaction color with semibold text and a 2pt bottom border.
/// Inactive tabs use subdued text color with regular weight.
/// A 1pt bottom border separates the tab strip from content below.
///
/// ```swift
/// @State var selected = "accounts"
///
/// ADIBTabs(
///     items: [
///         ADIBTabsItem(id: "accounts", title: "Accounts", icon: Image(systemName: "building.columns")),
///         ADIBTabsItem(id: "cards", title: "Cards", icon: Image(systemName: "creditcard")),
///     ],
///     selection: $selected
/// )
/// ```
public struct ADIBTabs: View {

    // MARK: - Properties

    private let items: [ADIBTabsItem]
    @Binding private var selection: String

    // MARK: - Constants

    private let iconSize: CGFloat = ADIBSizes.Spacing.large          // 24
    private let iconLabelSpacing: CGFloat = ADIBSizes.Spacing.small   // 8
    private let horizontalPadding: CGFloat = ADIBSizes.Spacing.small  // 8
    private let bottomPadding: CGFloat = ADIBSizes.Spacing.medium     // 16
    private let indicatorHeight: CGFloat = 2

    // MARK: - Init

    /// Creates an ADIB tab strip.
    /// - Parameters:
    ///   - items: The tab items to display.
    ///   - selection: A binding to the currently selected tab's id.
    public init(
        items: [ADIBTabsItem],
        selection: Binding<String>
    ) {
        self.items = items
        self._selection = selection
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                tabView(for: item)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .overlay(alignment: .bottom) {
            // Full-width bottom border
            ADIBColors.border
                .frame(height: 1)
        }
    }

    // MARK: - Tab View

    @ViewBuilder
    private func tabView(for item: ADIBTabsItem) -> some View {
        let isActive = selection == item.id

        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = item.id
            }
        } label: {
            VStack(spacing: iconLabelSpacing) {
                (isActive ? (item.activeIcon ?? item.icon) : item.icon)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)

                Text(item.title)
                    .font(.system(
                        size: ADIBSizes.Font.two,        // 14
                        weight: isActive ? .semibold : .regular
                    ))
                    .tracking(-0.15)
                    .lineSpacing(ADIBTypography.caption.regular.lineSpacing)
            }
            .foregroundStyle(
                isActive
                    ? ADIBColors.interaction
                    : ADIBColors.Text.subdued
            )
            .frame(maxWidth: .infinity)
            .padding(.bottom, bottomPadding)
            .overlay(alignment: .bottom) {
                // Active indicator
                if isActive {
                    ADIBColors.interaction
                        .frame(height: indicatorHeight)
                        .transition(.opacity)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Tabs") {
    struct TabsPreview: View {
        @State private var selected = "accounts"

        var body: some View {
            VStack(spacing: 0) {
                ADIBTabs(
                    items: [
                        ADIBTabsItem(
                            id: "accounts",
                            title: "Accounts",
                            icon: Image(systemName: "building.columns"),
                            activeIcon: Image(systemName: "building.columns.fill")
                        ),
                        ADIBTabsItem(
                            id: "cards",
                            title: "Cards",
                            icon: Image(systemName: "creditcard"),
                            activeIcon: Image(systemName: "creditcard.fill")
                        ),
                        ADIBTabsItem(
                            id: "wealth",
                            title: "Wealth",
                            icon: Image(systemName: "chart.line.uptrend.xyaxis"),
                            activeIcon: Image(systemName: "chart.line.uptrend.xyaxis")
                        ),
                        ADIBTabsItem(
                            id: "finance",
                            title: "Finance",
                            icon: Image(systemName: "banknote"),
                            activeIcon: Image(systemName: "banknote.fill")
                        ),
                        ADIBTabsItem(
                            id: "takaful",
                            title: "Takaful",
                            icon: Image(systemName: "checkmark.shield"),
                            activeIcon: Image(systemName: "checkmark.shield.fill")
                        ),
                    ],
                    selection: $selected
                )

                Spacer()

                Text("Selected: \(selected)")
                    .adibTextStyle(ADIBTypography.h3.semibold)

                Spacer()
            }
            .background(ADIBColors.background)
        }
    }

    return TabsPreview()
}
#endif
