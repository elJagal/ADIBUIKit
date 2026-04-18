import SwiftUI

// MARK: - Detail List Item Data

/// A single row in a detail list card.
public struct ADIBDetailListItemData: Identifiable {
    public let id: String
    public let heading: String
    public let description: String

    public init(
        id: String = UUID().uuidString,
        heading: String,
        description: String
    ) {
        self.id = id
        self.heading = heading
        self.description = description
    }
}

// MARK: - Detail List Card Component

/// A detail list card from the ADIB design system.
///
/// Displays a main heading with an optional trailing image (e.g. a flag),
/// followed by a list of heading + description rows separated by lines.
///
/// Pass an array of items and optionally limit how many are visible
/// with `visibleItemCount`.
///
/// ```swift
/// ADIBDetailListCard(
///     heading: "Transfer details",
///     trailingImage: Image("uk-flag"),
///     items: [
///         ADIBDetailListItemData(heading: "From", description: "Current account • 0711"),
///         ADIBDetailListItemData(heading: "To", description: "Mohammed Ahmed • 1234"),
///         ADIBDetailListItemData(heading: "Amount", description: "AED 20,000.00"),
///     ]
/// )
///
/// // Show only first 3 of 5 items
/// ADIBDetailListCard(
///     heading: "Summary",
///     items: allItems,
///     visibleItemCount: 3
/// )
/// ```
public struct ADIBDetailListCard: View {

    // MARK: - Properties

    private let heading: String?
    private let trailingImage: Image?
    private let showTrailingImage: Bool
    private let items: [ADIBDetailListItemData]
    private let visibleItemCount: Int?
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let containerRadius: CGFloat = ADIBSizes.Radius.default            // 20
    private let verticalPadding: CGFloat = 12
    private let horizontalPadding: CGFloat = 20
    private let itemGap: CGFloat = 12
    private let textGap: CGFloat = ADIBSizes.Spacing.xsmall                    // 4
    private let trailingImageSize: CGFloat = ADIBSizes.Spacing.large           // 24
    private let separatorHeight: CGFloat = 0.5

    // MARK: - Computed

    /// The items actually displayed, capped by `visibleItemCount`.
    private var displayedItems: [ADIBDetailListItemData] {
        if let count = visibleItemCount {
            return Array(items.prefix(min(count, 10)))
        }
        return Array(items.prefix(10))
    }

    // MARK: - Init

    /// Creates a detail list card.
    /// - Parameters:
    ///   - heading: Optional main heading at the top.
    ///   - trailingImage: Optional trailing image (e.g. flag), shown top-right.
    ///   - showTrailingImage: Whether to show the trailing image (default `true`).
    ///   - items: Array of heading + description row data.
    ///   - visibleItemCount: How many items to show (nil = all, max 10).
    ///   - onTap: Optional tap action for the card.
    public init(
        heading: String? = nil,
        trailingImage: Image? = nil,
        showTrailingImage: Bool = true,
        items: [ADIBDetailListItemData],
        visibleItemCount: Int? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.heading = heading
        self.trailingImage = trailingImage
        self.showTrailingImage = showTrailingImage
        self.items = items
        self.visibleItemCount = visibleItemCount
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        let content = cardContent

        if let onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }

    // MARK: - Card Content

    private var cardContent: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: itemGap) {
                // Main heading
                if let heading, !heading.isEmpty {
                    Text(heading)
                        .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                        .padding(.horizontal, horizontalPadding)
                }

                // Item rows
                ForEach(Array(displayedItems.enumerated()), id: \.element.id) { index, item in
                    VStack(alignment: .leading, spacing: itemGap) {
                        // Heading + Description
                        VStack(alignment: .leading, spacing: textGap) {
                            Text(item.heading)
                                .adibTextStyle(ADIBTypography.body.regular, color: ADIBColors.Text.base)

                            Text(item.description)
                                .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                        }
                        .padding(.horizontal, horizontalPadding)

                        // Separator — not on last item
                        if index < displayedItems.count - 1 {
                            Rectangle()
                                .fill(ADIBColors.border)
                                .frame(height: separatorHeight)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding(.vertical, verticalPadding)

            // Trailing image (flag)
            if showTrailingImage, let trailingImage {
                trailingImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: trailingImageSize, height: trailingImageSize)
                    .clipShape(Circle())
                    .padding(.top, verticalPadding)
                    .padding(.trailing, horizontalPadding)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: containerRadius)
                .fill(ADIBColors.Surface.blueTwo)
        )
        .clipShape(RoundedRectangle(cornerRadius: containerRadius))
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Detail List Card — 5 Items") {
    ADIBDetailListCard(
        heading: "Heading",
        trailingImage: Image(systemName: "flag.circle.fill"),
        items: [
            ADIBDetailListItemData(heading: "Heading 1", description: "Description goes here"),
            ADIBDetailListItemData(heading: "Heading 2", description: "Description goes here"),
            ADIBDetailListItemData(heading: "Heading 3", description: "Description goes here"),
            ADIBDetailListItemData(heading: "Heading 4", description: "Description goes here"),
            ADIBDetailListItemData(heading: "Heading 5", description: "Description goes here"),
        ]
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Detail List Card — Limited to 3") {
    ADIBDetailListCard(
        heading: "Transfer details",
        items: [
            ADIBDetailListItemData(heading: "From", description: "Current account • 0711"),
            ADIBDetailListItemData(heading: "To", description: "Mohammed Ahmed • 1234"),
            ADIBDetailListItemData(heading: "Amount", description: "AED 20,000.00"),
            ADIBDetailListItemData(heading: "Reference", description: "TRN-20240415-001"),
            ADIBDetailListItemData(heading: "Status", description: "Pending"),
        ],
        visibleItemCount: 3
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}

#Preview("Detail List Card — No Heading, No Image") {
    ADIBDetailListCard(
        items: [
            ADIBDetailListItemData(heading: "Account", description: "Savings • 4521"),
            ADIBDetailListItemData(heading: "Balance", description: "AED 150,000.00"),
        ]
    )
    .padding(.horizontal, ADIBSizes.Spacing.medium)
    .background(ADIBColors.background)
}
#endif
