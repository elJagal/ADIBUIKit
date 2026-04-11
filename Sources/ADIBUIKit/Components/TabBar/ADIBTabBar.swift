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
/// ADIBTabBar(
///     items: [
///         ADIBTabItem(id: "home", title: "Home", icon: Image(systemName: "square.grid.2x2")),
///         ADIBTabItem(id: "pay", title: "Pay", icon: Image(systemName: "banknote")),
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

    // MARK: - Init

    /// Creates an ADIB tab bar.
    /// - Parameters:
    ///   - items: The tab items to display.
    ///   - selection: A binding to the currently selected tab's id.
    public init(
        items: [ADIBTabItem],
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

                ADIBTabBar(
                    items: [
                        ADIBTabItem(
                            id: "home",
                            title: "Home",
                            icon: Image(systemName: "square.grid.2x2"),
                            activeIcon: Image(systemName: "square.grid.2x2.fill")
                        ),
                        ADIBTabItem(
                            id: "pay",
                            title: "Pay",
                            icon: Image(systemName: "banknote"),
                            activeIcon: Image(systemName: "banknote.fill")
                        ),
                        ADIBTabItem(
                            id: "transfer",
                            title: "Transfer",
                            icon: Image(systemName: "arrow.left.arrow.right"),
                            activeIcon: Image(systemName: "arrow.left.arrow.right")
                        ),
                        ADIBTabItem(
                            id: "invest",
                            title: "Invest",
                            icon: Image(systemName: "chart.bar"),
                            activeIcon: Image(systemName: "chart.bar.fill")
                        ),
                        ADIBTabItem(
                            id: "exceed",
                            title: "Exceed",
                            icon: Image(systemName: "creditcard"),
                            activeIcon: Image(systemName: "creditcard.fill")
                        ),
                    ],
                    selection: $selected
                )
            }
            .background(ADIBColors.background)
            .ignoresSafeArea(edges: .bottom)
        }
    }

    return TabBarPreview()
}
#endif
