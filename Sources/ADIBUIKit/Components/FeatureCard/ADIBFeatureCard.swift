import SwiftUI

// MARK: - Feature Card Item

/// A single feature card item.
public struct ADIBFeatureCardItem: Identifiable {
    public let id: String
    public let image: Image
    public let title: String
    public let subtitle: String
    public var showBeta: Bool
    public let onTap: (() -> Void)?

    public init(
        id: String,
        image: Image,
        title: String,
        subtitle: String,
        showBeta: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.id = id
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.showBeta = showBeta
        self.onTap = onTap
    }
}

// MARK: - Feature Card Stack

/// A container that displays feature cards.
///
/// - **1 item**: renders as a horizontal card (image left, text right)
/// - **2+ items**: renders as vertical cards (image top, text bottom) in a horizontal row
///
/// ```swift
/// ADIBFeatureCardStack(items: [
///     ADIBFeatureCardItem(id: "1", image: Image("money"), title: "Your money", subtitle: "Cashflow & spend", showBeta: true),
///     ADIBFeatureCardItem(id: "2", image: Image("family"), title: "Family", subtitle: "Manage family")
/// ])
/// ```
public struct ADIBFeatureCardStack: View {

    // MARK: - Properties

    private let items: [ADIBFeatureCardItem]

    // MARK: - Init

    public init(items: [ADIBFeatureCardItem]) {
        self.items = items
    }

    // MARK: - Body

    public var body: some View {
        if items.count == 1, let item = items.first {
            // Single item — horizontal layout
            ADIBFeatureCardHorizontal(item: item)
        } else {
            // Multiple items — vertical cards in a row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ADIBSizes.Spacing.small) {
                    ForEach(items) { item in
                        ADIBFeatureCardVertical(item: item)
                    }
                }
                .padding(.horizontal, ADIBSizes.Spacing.medium)
            }
        }
    }
}

// MARK: - Vertical Card (Image Top, Text Bottom)

/// Used when multiple cards are displayed in a row.
struct ADIBFeatureCardVertical: View {

    let item: ADIBFeatureCardItem

    // MARK: - Constants

    private let imageWidth: CGFloat = 162
    private let imageHeight: CGFloat = 89
    private let cornerRadius: CGFloat = ADIBSizes.Radius.medium // 16pt

    var body: some View {
        Button {
            item.onTap?()
        } label: {
            VStack(alignment: .leading, spacing: ADIBSizes.Spacing.small) {
                // Image container with optional Beta tag
                imageContainer

                // Text content
                textContent
            }
            .frame(width: imageWidth)
        }
        .buttonStyle(.plain)
    }

    private var imageContainer: some View {
        ZStack(alignment: .topTrailing) {
            item.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(ADIBColors.Surface.components)
                )

            if item.showBeta {
                ADIBTag("Beta", type: .warning, showLeadingIcon: false, showTrailingIcon: false)
                    .padding(ADIBSizes.Spacing.xsmall)
            }
        }
    }

    private var textContent: some View {
        VStack(alignment: .leading, spacing: ADIBSizes.Spacing.xsmall) {
            Text(item.title)
                .adibTextStyle(ADIBTypography.body.semibold)
                .lineLimit(1)

            Text(item.subtitle)
                .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
                .lineLimit(1)
        }
    }
}

// MARK: - Horizontal Card (Image Left, Text Right)

/// Used when only one card is displayed.
struct ADIBFeatureCardHorizontal: View {

    let item: ADIBFeatureCardItem

    // MARK: - Constants

    private let imageWidth: CGFloat = 162
    private let imageHeight: CGFloat = 89
    private let cornerRadius: CGFloat = ADIBSizes.Radius.medium // 16pt

    var body: some View {
        Button {
            item.onTap?()
        } label: {
            ZStack(alignment: .topTrailing) {
                HStack(spacing: ADIBSizes.Spacing.small) {
                    // Image
                    item.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageWidth, height: imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(ADIBColors.Surface.components)
                        )

                    // Text content
                    VStack(alignment: .leading, spacing: ADIBSizes.Spacing.xsmall) {
                        Text(item.title)
                            .adibTextStyle(ADIBTypography.body.semibold)
                            .lineLimit(1)

                        Text(item.subtitle)
                            .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
                            .lineLimit(2)
                    }

                    Spacer(minLength: 0)
                }

                // Beta tag
                if item.showBeta {
                    ADIBTag("Beta", type: .warning, showLeadingIcon: false, showTrailingIcon: false)
                        .padding(ADIBSizes.Spacing.xsmall)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
struct ADIBFeatureCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            // Single item — horizontal
            ADIBFeatureCardStack(items: [
                ADIBFeatureCardItem(
                    id: "1",
                    image: Image(systemName: "chart.pie.fill"),
                    title: "Your money",
                    subtitle: "Cashflow & spend",
                    showBeta: true
                )
            ])
            .padding(.horizontal, ADIBSizes.Spacing.medium)

            // Multiple items — vertical
            ADIBFeatureCardStack(items: [
                ADIBFeatureCardItem(
                    id: "1",
                    image: Image(systemName: "chart.pie.fill"),
                    title: "Your money",
                    subtitle: "Cashflow & spend",
                    showBeta: true
                ),
                ADIBFeatureCardItem(
                    id: "2",
                    image: Image(systemName: "person.2.fill"),
                    title: "Family",
                    subtitle: "Manage family",
                    showBeta: false
                )
            ])
        }
        .background(ADIBColors.background)
    }
}
#endif
