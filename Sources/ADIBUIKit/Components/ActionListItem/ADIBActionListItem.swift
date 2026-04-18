import SwiftUI

// MARK: - Action List Item

/// A navigation list item from the ADIB design system.
///
/// Displays a leading avatar, title, description, optional "New" tag,
/// and a trailing chevron icon. A bottom separator line is shown by default
/// and should be hidden on the last item in a list.
///
/// Uses the `ADIBAvatar` component for the leading icon.
///
/// ```swift
/// // Basic usage
/// ADIBActionListItem(
///     avatar: .squareIcon(Image("cash-filled")),
///     title: "Own accounts and cards",
///     description: "Transfer between your own ADIB accounts and cards.",
///     onTap: { }
/// )
///
/// // With "New" tag, no separator (last item)
/// ADIBActionListItem(
///     avatar: .squareIcon(Image("gift-filled")),
///     title: "Gift to Amwali",
///     description: "Send money to an Amwali account using their mobile number.",
///     showNewTag: true,
///     showSeparator: false,
///     onTap: { }
/// )
/// ```
public struct ADIBActionListItem: View {

    // MARK: - Properties

    private let avatar: ADIBAvatarType
    private let avatarIconColor: Color?
    private let avatarBackgroundColor: Color?
    private let title: String
    private let description: String
    private let showNewTag: Bool
    private let showSeparator: Bool
    private let trailingIcon: Image?
    private let onTap: (() -> Void)?

    // MARK: - Constants

    private let contentGap: CGFloat = ADIBSizes.Spacing.medium          // 16
    private let separatorGap: CGFloat = ADIBSizes.Spacing.medium        // 16
    private let trailingIconSize: CGFloat = ADIBSizes.Spacing.large     // 24
    private let avatarSize: CGFloat = 48
    private let separatorLeading: CGFloat = 64                          // avatar(48) + gap(16)
    private let tagRadius: CGFloat = 6
    private let tagHorizontalPadding: CGFloat = 6
    private let tagVerticalPadding: CGFloat = 1
    private let tagTopOffset: CGFloat = -7

    // MARK: - Init

    /// Creates an action list item.
    /// - Parameters:
    ///   - avatar: The avatar type for the leading icon.
    ///   - avatarIconColor: Optional override for the avatar icon tint.
    ///   - avatarBackgroundColor: Optional override for the avatar background.
    ///   - title: The primary text (body semibold).
    ///   - description: The secondary text (caption regular, subdued).
    ///   - showNewTag: Whether to show a "New" badge on the avatar (default `false`).
    ///   - showSeparator: Whether to show the bottom separator line (default `true`).
    ///   - trailingIcon: Custom trailing icon. Defaults to `chevron-right` from app assets.
    ///   - onTap: The action when the item is tapped.
    public init(
        avatar: ADIBAvatarType,
        avatarIconColor: Color? = nil,
        avatarBackgroundColor: Color? = nil,
        title: String,
        description: String,
        showNewTag: Bool = false,
        showSeparator: Bool = true,
        trailingIcon: Image? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.avatar = avatar
        self.avatarIconColor = avatarIconColor
        self.avatarBackgroundColor = avatarBackgroundColor
        self.title = title
        self.description = description
        self.showNewTag = showNewTag
        self.showSeparator = showSeparator
        self.trailingIcon = trailingIcon
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button {
            onTap?()
        } label: {
            VStack(spacing: separatorGap) {
                // Content row
                HStack(spacing: contentGap) {
                    // Leading avatar with optional "New" tag
                    avatarView

                    // Text content
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                            .lineLimit(2)

                        Text(description)
                            .adibTextStyle(ADIBTypography.caption.regular, color: ADIBColors.Text.subdued)
                            .lineLimit(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Trailing chevron
                    (trailingIcon ?? Image(systemName: "chevron.right"))
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: trailingIconSize, height: trailingIconSize)
                        .foregroundStyle(ADIBColors.Text.subdued)
                }

                // Separator line — starts aligned with the text (after avatar + gap)
                if showSeparator {
                    Rectangle()
                        .fill(ADIBColors.border)
                        .frame(height: 0.5)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, separatorLeading)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Avatar with New Tag

    private var avatarView: some View {
        ZStack(alignment: .top) {
            ADIBAvatar(
                type: avatar,
                iconColor: avatarIconColor,
                backgroundColor: avatarBackgroundColor
            )

            if showNewTag {
                Text("New")
                    .adibTextStyle(ADIBTypography.caption.regular, color: .white)
                    .padding(.horizontal, tagHorizontalPadding)
                    .padding(.vertical, tagVerticalPadding)
                    .background(
                        RoundedRectangle(cornerRadius: tagRadius)
                            .fill(ADIBColors.Semantic.Success.two)
                    )
                    .offset(y: tagTopOffset)
            }
        }
    }
}

// MARK: - Action List

/// A convenience wrapper that renders a vertical list of `ADIBActionListItem`
/// and automatically hides the separator on the last item.
///
/// ```swift
/// ADIBActionList(items: [
///     ADIBActionListItemData(
///         avatar: .squareIcon(Image("cash-filled")),
///         title: "Own accounts",
///         description: "Transfer between your own accounts."
///     ),
///     ADIBActionListItemData(
///         avatar: .squareIcon(Image("wallet-filled")),
///         title: "Gift to Amwali",
///         description: "Send money to an Amwali account.",
///         showNewTag: true
///     )
/// ]) { item in
///     print("Tapped: \(item.title)")
/// }
/// ```
public struct ADIBActionListItemData: Identifiable {
    public let id: String
    public let avatar: ADIBAvatarType
    public let avatarIconColor: Color?
    public let avatarBackgroundColor: Color?
    public let title: String
    public let description: String
    public let showNewTag: Bool

    public init(
        id: String = UUID().uuidString,
        avatar: ADIBAvatarType,
        avatarIconColor: Color? = nil,
        avatarBackgroundColor: Color? = nil,
        title: String,
        description: String,
        showNewTag: Bool = false
    ) {
        self.id = id
        self.avatar = avatar
        self.avatarIconColor = avatarIconColor
        self.avatarBackgroundColor = avatarBackgroundColor
        self.title = title
        self.description = description
        self.showNewTag = showNewTag
    }
}

public struct ADIBActionList: View {

    private let items: [ADIBActionListItemData]
    private let trailingIcon: Image?
    private let onTap: ((ADIBActionListItemData) -> Void)?

    /// Creates an action list.
    /// - Parameters:
    ///   - items: The list item data.
    ///   - trailingIcon: Custom trailing icon for all items. Defaults to chevron.right.
    ///   - onTap: The action when an item is tapped.
    public init(
        items: [ADIBActionListItemData],
        trailingIcon: Image? = nil,
        onTap: ((ADIBActionListItemData) -> Void)? = nil
    ) {
        self.items = items
        self.trailingIcon = trailingIcon
        self.onTap = onTap
    }

    public var body: some View {
        VStack(spacing: ADIBSizes.Spacing.medium) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ADIBActionListItem(
                    avatar: item.avatar,
                    avatarIconColor: item.avatarIconColor,
                    avatarBackgroundColor: item.avatarBackgroundColor,
                    title: item.title,
                    description: item.description,
                    showNewTag: item.showNewTag,
                    showSeparator: index < items.count - 1,
                    trailingIcon: trailingIcon
                ) {
                    onTap?(item)
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Action List") {
    ScrollView {
        ADIBActionList(items: [
            ADIBActionListItemData(
                avatar: .squareIcon(Image(systemName: "arrow.left.arrow.right")),
                title: "Own accounts and cards",
                description: "Transfer between your own ADIB accounts and cards."
            ),
            ADIBActionListItemData(
                avatar: .squareIcon(Image(systemName: "building.2.fill")),
                title: "Other ADIB customers",
                description: "Transfer to accounts or cards held by other ADIB customers."
            ),
            ADIBActionListItemData(
                avatar: .squareIcon(Image(systemName: "banknote.fill")),
                title: "Cardless Cash",
                description: "Withdraw money from an ATM without a card for self or others."
            ),
            ADIBActionListItemData(
                avatar: .squareIcon(Image(systemName: "person.2.fill")),
                title: "Child accounts",
                description: "Transfer between your child's ADIB accounts and your accounts.",
                showNewTag: true
            ),
            ADIBActionListItemData(
                avatar: .squareIcon(Image(systemName: "gift.fill")),
                title: "Gift to Amwali",
                description: "Send money to an Amwali account using their mobile number."
            )
        ]) { item in
            print("Tapped: \(item.title)")
        }
        .padding(.horizontal, ADIBSizes.Spacing.medium)
        .padding(.top, ADIBSizes.Spacing.medium)
    }
    .background(ADIBColors.background)
}

#Preview("Single Action Item") {
    ADIBActionListItem(
        avatar: .squareIcon(Image(systemName: "creditcard.fill")),
        title: "Own accounts and cards",
        description: "Transfer between your own ADIB accounts and cards.",
        showNewTag: true,
        showSeparator: true
    )
    .padding()
    .background(ADIBColors.background)
}
#endif
