import SwiftUI

// MARK: - Story Item Model

/// A single story item for the What's New component.
public struct ADIBStoryItem: Identifiable {
    public let id: String
    public let image: Image
    public let title: String
    public var isSeen: Bool

    public init(
        id: String,
        image: Image,
        title: String,
        isSeen: Bool = false
    ) {
        self.id = id
        self.image = image
        self.title = title
        self.isSeen = isSeen
    }
}

// MARK: - What's New Component

/// A horizontally scrollable row of story circles, similar to Instagram stories.
///
/// - **Unseen**: Blue gradient ring around circle, gradient background, `Text.base` label
/// - **Seen**: No ring, `Surface.blueTwo` background, `Text.subdued` label
///
/// The component renders items in the order provided. Reordering (e.g. moving
/// seen stories to the end) is the responsibility of the parent view.
///
/// ```swift
/// ADIBWhatsNew(items: stories) { story in
///     print("Tapped: \(story.title)")
/// }
/// ```
public struct ADIBWhatsNew: View {

    // MARK: - Properties

    private let items: [ADIBStoryItem]
    private let onItemTap: ((ADIBStoryItem) -> Void)?

    // MARK: - Constants

    private let circleSize: CGFloat = 74
    private let ringSize: CGFloat = 82
    private let strokeWidth: CGFloat = ADIBSizes.Spacing.xxsmall // 2pt
    private let itemWidth: CGFloat = 76
    private let itemSpacing: CGFloat = ADIBSizes.Spacing.large   // 24pt

    // MARK: - Init

    /// Creates a What's New story strip.
    /// - Parameters:
    ///   - items: The story items to display
    ///   - onItemTap: Action when a story is tapped
    public init(
        items: [ADIBStoryItem],
        onItemTap: ((ADIBStoryItem) -> Void)? = nil
    ) {
        self.items = items
        self.onItemTap = onItemTap
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: itemSpacing) {
                ForEach(items) { item in
                    storyItemView(item)
                        .onTapGesture {
                            onItemTap?(item)
                        }
                }
            }
            .padding(.horizontal, ADIBSizes.Spacing.medium)
        }
    }

    // MARK: - Story Item View

    private func storyItemView(_ item: ADIBStoryItem) -> some View {
        VStack(spacing: ADIBSizes.Spacing.small) {
            // Circle with image
            storyCircle(item)

            // Title label
            Text(item.title)
                .adibTextStyle(
                    ADIBTypography.caption.regular,
                    color: item.isSeen ? ADIBColors.Text.subdued : ADIBColors.Text.base
                )
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: itemWidth)
        }
    }

    private func storyCircle(_ item: ADIBStoryItem) -> some View {
        ZStack {
            // Circle background
            Circle()
                .fill(
                    item.isSeen
                        ? AnyShapeStyle(ADIBColors.Surface.blueTwo)
                        : AnyShapeStyle(ADIBColors.Gradients.gradientPaletteBlue)
                )
                .frame(width: circleSize, height: circleSize)

            // Story image
            item.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: circleSize, height: circleSize)
                .clipShape(Circle())

            // Gradient ring for unseen stories — 2pt stroke on 82pt circle
            if !item.isSeen {
                Circle()
                    .strokeBorder(
                        ADIBColors.Gradients.gradientStoryRing,
                        lineWidth: strokeWidth
                    )
                    .frame(width: ringSize, height: ringSize)
            }
        }
        .frame(width: ringSize, height: ringSize)
    }
}

// MARK: - Preview

#if DEBUG
struct ADIBWhatsNew_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ADIBWhatsNew(items: [
                ADIBStoryItem(
                    id: "1",
                    image: Image(systemName: "car.fill"),
                    title: "Win with Ghina",
                    isSeen: false
                ),
                ADIBStoryItem(
                    id: "2",
                    image: Image(systemName: "airplane"),
                    title: "Travel, spend & win",
                    isSeen: false
                ),
                ADIBStoryItem(
                    id: "3",
                    image: Image(systemName: "creditcard.fill"),
                    title: "Get a covered card",
                    isSeen: true
                ),
                ADIBStoryItem(
                    id: "4",
                    image: Image(systemName: "lock.fill"),
                    title: "Covered Card PIN",
                    isSeen: true
                )
            ]) { item in
                print("Tapped: \(item.title)")
            }
        }
        .background(ADIBColors.background)
    }
}
#endif
