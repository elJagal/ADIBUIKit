import SwiftUI

// MARK: - Avatar Type

/// The visual variant for the avatar component.
public enum ADIBAvatarType {
    /// A circular container with a template icon (e.g. camera icon for profile).
    /// Uses `ADIBColors.Segment.surface` background by default.
    case circleIcon(Image)

    /// A circular container showing a profile photo.
    case profileImage(Image)

    /// A square container showing the user's initials, extracted from the label.
    /// Pass the full name (e.g. "Ahmed Mohamed") and the initials ("AM") are computed automatically.
    /// Uses `ADIBColors.Surface.yellow` background by default.
    case initials(String)

    /// A square container showing the Mastercard logo.
    /// Uses `ADIBColors.Surface.yellow` background by default.
    case mastercard(Image)

    /// A square container with a template icon (e.g. cash, wallet, credit-card).
    /// Uses `ADIBColors.Segment.surface` background by default.
    case squareIcon(Image)

    /// A square container filled with a full image (e.g. Starbucks, product image).
    case image(Image)

    /// A square container showing the Visa logo.
    /// Uses `ADIBColors.Segment.surface` background by default.
    case visa(Image)

    /// A circular container showing the ADIB logo.
    case adibLogo(Image)
}

// MARK: - Avatar Component

/// A versatile avatar component from the ADIB design system.
///
/// Displays an icon, image, initials, or brand logo inside a styled container.
/// Supports both circular and square shapes depending on the variant.
///
/// **Variants:**
/// - `circleIcon` — Icon on circular surface (profile placeholder)
/// - `profileImage` — Photo in circle (user avatar)
/// - `initials` — Initials from label on yellow surface
/// - `mastercard` — Mastercard logo on yellow surface
/// - `squareIcon` — Icon on square surface (accounts, cards)
/// - `image` — Full image in square (merchant logos)
/// - `visa` — Visa logo on segment surface
/// - `adibLogo` — ADIB logo in circle
///
/// ```swift
/// // Square icon (for accounts)
/// ADIBAvatar(type: .squareIcon(Image("wallet-filled")))
///
/// // Initials from full name
/// ADIBAvatar(type: .initials("Ahmed Mohamed"))
///
/// // Profile image
/// ADIBAvatar(type: .profileImage(Image("profile-photo")))
/// ```
public struct ADIBAvatar: View {

    // MARK: - Properties

    private let type: ADIBAvatarType
    private let iconColor: Color?
    private let backgroundColor: Color?

    // MARK: - Constants

    private let size: CGFloat = 48
    private let iconSize: CGFloat = 24
    private let containerPadding: CGFloat = 12
    private let squareRadius: CGFloat = ADIBSizes.Radius.small       // 12
    private let circleRadius: CGFloat = 34                           // effectively full circle at 48pt

    // MARK: - Init

    /// Creates an avatar component.
    /// - Parameters:
    ///   - type: The visual variant to display.
    ///   - iconColor: Optional override for the icon tint color.
    ///   - backgroundColor: Optional override for the container background color.
    public init(
        type: ADIBAvatarType,
        iconColor: Color? = nil,
        backgroundColor: Color? = nil
    ) {
        self.type = type
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
    }

    // MARK: - Computed

    /// Whether this variant uses a circular shape.
    private var isCircular: Bool {
        switch type {
        case .circleIcon, .profileImage, .adibLogo:
            return true
        default:
            return false
        }
    }

    /// The corner radius based on shape.
    private var cornerRadius: CGFloat {
        isCircular ? circleRadius : squareRadius
    }

    /// The default background color for this variant.
    private var defaultBackgroundColor: Color {
        switch type {
        case .initials, .mastercard:
            return ADIBColors.Surface.yellow
        case .circleIcon, .squareIcon, .visa:
            return ADIBColors.Segment.surface
        case .profileImage, .image, .adibLogo:
            return .clear
        }
    }

    /// The default icon tint color.
    private var defaultIconColor: Color {
        ADIBColors.Segment.accent
    }

    /// Extracts initials from a full name string.
    /// - "Ahmed Mohamed" → "AM"
    /// - "Ahmed" → "A"
    /// - "" → ""
    private func extractInitials(from name: String) -> String {
        let components = name.trimmingCharacters(in: .whitespaces)
            .split(separator: " ")
            .filter { !$0.isEmpty }

        switch components.count {
        case 0:
            return ""
        case 1:
            return String(components[0].prefix(1)).uppercased()
        default:
            let first = String(components[0].prefix(1)).uppercased()
            let last = String(components[components.count - 1].prefix(1)).uppercased()
            return first + last
        }
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch type {

            // MARK: Circle + Icon
            case .circleIcon(let icon):
                iconContainer(icon: icon, isCircle: true)

            // MARK: Profile Image
            case .profileImage(let photo):
                photo
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())

            // MARK: Initials
            case .initials(let label):
                Text(extractInitials(from: label))
                    .adibTextStyle(ADIBTypography.body.semibold, color: ADIBColors.Text.base)
                    .frame(width: size, height: size)
                    .background(
                        RoundedRectangle(cornerRadius: squareRadius)
                            .fill(backgroundColor ?? defaultBackgroundColor)
                    )

            // MARK: Mastercard
            case .mastercard(let logo):
                logoContainer(logo: logo, bgColor: ADIBColors.Surface.yellow)

            // MARK: Square + Icon
            case .squareIcon(let icon):
                iconContainer(icon: icon, isCircle: false)

            // MARK: Image
            case .image(let img):
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: squareRadius))

            // MARK: Visa
            case .visa(let logo):
                logoContainer(logo: logo, bgColor: ADIBColors.Segment.surface)

            // MARK: ADIB Logo
            case .adibLogo(let logo):
                logo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
        }
    }

    // MARK: - Subviews

    /// An icon (template-rendered) centered in a padded container.
    private func iconContainer(icon: Image, isCircle: Bool) -> some View {
        icon
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconSize, height: iconSize)
            .foregroundStyle(iconColor ?? defaultIconColor)
            .frame(width: size, height: size)
            .background(
                Group {
                    if isCircle {
                        Circle()
                            .fill(backgroundColor ?? defaultBackgroundColor)
                    } else {
                        RoundedRectangle(cornerRadius: squareRadius)
                            .fill(backgroundColor ?? defaultBackgroundColor)
                    }
                }
            )
    }

    /// A brand logo (original colors) centered in a padded container.
    private func logoContainer(logo: Image, bgColor: Color) -> some View {
        logo
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconSize, height: iconSize)
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: squareRadius)
                    .fill(backgroundColor ?? bgColor)
            )
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Avatar Variants") {
    VStack(spacing: ADIBSizes.Spacing.large) {

        // Circle + Icon
        ADIBAvatar(type: .circleIcon(Image(systemName: "camera.fill")))

        // Profile Image
        ADIBAvatar(type: .profileImage(Image(systemName: "person.crop.circle.fill")))

        // Initials
        ADIBAvatar(type: .initials("Ahmed Mohamed"))

        // Square + Icon
        ADIBAvatar(type: .squareIcon(Image(systemName: "creditcard.fill")))

        // Image
        ADIBAvatar(type: .image(Image(systemName: "photo.fill")))
    }
    .padding()
    .background(ADIBColors.background)
}
#endif
