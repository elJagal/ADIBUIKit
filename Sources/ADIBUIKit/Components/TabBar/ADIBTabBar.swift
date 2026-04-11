import SwiftUI

/// A tab bar item model for the ADIB tab bar.
///
/// Each item has a title, an inactive icon, and an optional active icon.
/// If no active icon is provided, the inactive icon is used for both states.
public struct ADIBTabItem: Identifiable, Hashable {

    public let id: String
    public let title: String
    public let icon: Image
    public let activeIcon: Image?

    /// Creates a tab bar item.
    /// - Parameters:
    ///   - id: Unique identifier for the tab (used as the selection value).
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

    public static func == (lhs: ADIBTabItem, rhs: ADIBTabItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// A bottom tab bar from the ADIB design system.
///
/// Displays a horizontal row of tabs with icons and labels.
/// Active tab uses the interaction color, inactive uses subdued text color.
/// Includes a top shadow and blur effect matching the Figma spec.
///
/// ```swift
/// @State var selected = "home"
///
/// // Use default ADIB tabs (Home, Pay, Transfer, Invest, Exceed):
/// ADIBTabBar(selection: $selected)
///
/// // Or provide custom tabs:
/// ADIBTabBar(
///     items: [
///         ADIBTabItem(id: "home", title: "Home", icon: Image("layout-dashboard")),
///         ADIBTabItem(id: "pay", title: "Pay", icon: Image("cash")),
///     ],
///     selection: $selected
/// )
/// ```
public struct ADIBTabBar: View {

    // MARK: - Properties

    private let items: [ADIBTabItem]
    @Binding private var selection: String

    // MARK: - Constants

    private let barHeight: CGFloat = 69
    private let iconSize: CGFloat = ADIBSizes.Spacing.large        // 24
    private let verticalPadding: CGFloat = ADIBSizes.Spacing.medium // 16
    private let iconLabelSpacing: CGFloat = ADIBSizes.Spacing.xsmall // 4

    // MARK: - Default Items

    /// The default ADIB tab bar items (Home, Pay, Transfer, Invest, Exceed).
    /// Requires the corresponding icon assets in your app's asset catalog.
    public static let defaultItems: [ADIBTabItem] = [
        ADIBTabItem(
            id: "home",
            title: "Home",
            icon: Image("layout-dashboard"),
            activeIcon: Image("layout-dashboard-filled")
        ),
        ADIBTabItem(
            id: "pay",
            title: "Pay",
            icon: Image("cash"),
            activeIcon: Image("cash-filled")
        ),
        ADIBTabItem(
            id: "transfer",
            title: "Transfer",
            icon: Image("arrow-left-right"),
            activeIcon: Image("arrow-left-right")
        ),
        ADIBTabItem(
            id: "invest",
            title: "Invest",
            icon: Image("invest-chart"),
            activeIcon: Image("invest-chart-filled")
        ),
        ADIBTabItem(
            id: "exceed",
            title: "Exceed",
            icon: Image("Exceed"),
            activeIcon: Image("Exceed")
        ),
    ]

    // MARK: - Init

    /// Creates an ADIB tab bar.
    /// - Parameters:
    ///   - items: The tab items to display. Defaults to the standard ADIB tabs.
    ///   - selection: A binding to the currently selected tab's id.
    public init(
        items: [ADIBTabItem] = ADIBTabBar.defaultItems,
        selection: Binding<String>
    ) {
        self.items = items
        self._selection = selection
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(items) { item in
                    tabButton(for: item)
                }
            }
            .frame(height: barHeight)
            .frame(maxWidth: .infinity)
            .padding(.bottom, ADIBSizes.Spacing.large) // 24pt bottom padding
            .background(
                ADIBColors.background
                    .shadow(.drop(color: .black.opacity(0.1), radius: 7.5, y: -2))
            )
        }
    }

    // MARK: - Tab Button

    @ViewBuilder
    private func tabButton(for item: ADIBTabItem) -> some View {
        let isActive = selection == item.id

        Button {
            selection = item.id
        } label: {
            VStack(spacing: iconLabelSpacing) {
                (isActive ? (item.activeIcon ?? item.icon) : item.icon)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)

                Text(item.title)
                    .font(.system(size: ADIBSizes.Font.tabLabel))
                    .tracking(-0.043)
            }
            .foregroundStyle(
                isActive
                    ? ADIBColors.interaction
                    : ADIBColors.Text.subdued
            )
            .frame(maxWidth: .infinity)
            .frame(height: barHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Tab Bar") {
    struct TabBarPreview: View {
        @State private var selected = "home"

        var body: some View {
            VStack {
                Spacer()

                Text("Selected: \(selected)")
                    .adibTextStyle(ADIBTypography.h3.semibold)

                Spacer()

                ADIBTabBar(selection: $selected)
            }
            .background(ADIBColors.background)
            .ignoresSafeArea(edges: .bottom)
        }
    }

    return TabBarPreview()
}
#endif
