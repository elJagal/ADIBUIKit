# ADIBUIKit

A SwiftUI component library for the ADIB design system.

## Installation

Add this package via Swift Package Manager:

```
https://github.com/elJagal/ADIBUIKit.git
```

**Minimum:** iOS 16+ / macOS 13+

## Components

### PrimaryButton

Filled primary action button. States: default, tapped, disabled, loading.

```swift
PrimaryButton("Done") { print("Tapped") }
PrimaryButton("Submit", isLoading: true) {}
PrimaryButton("Continue") {}.disabled(true)
```

### SecondaryButton

Outlined button with border. States: default, tapped, disabled, loading.

```swift
SecondaryButton("Done") { print("Tapped") }
SecondaryButton("Cancel") {}.disabled(true)
SecondaryButton("Loading", isLoading: true) {}
```

### TertiaryButton

Text + optional icon, no background or border. Tapped: 60% opacity, Disabled: 20% opacity.

```swift
TertiaryButton("Done") {}
TertiaryButton("Add", icon: Image(systemName: "plus.circle.fill")) {}
TertiaryButton("Done", showIcon: false) {}
```

### LinkButton

Inline text + optional icon. Tapped: 60% opacity.

```swift
LinkButton("Done") {}
LinkButton("Learn more", showIcon: false) {}
```

### SlideButton

Drag-to-confirm slider. States: default, confirmed (green check), disabled.

```swift
SlideButton("Slide to confirm") { print("Confirmed!") }
SlideButton("Slide to confirm") {}.disabled(true)
```

## Design Tokens

### Colors — `ADIBColors`

75 color tokens: Semantic, Primitive, Brand, Buttons, Surfaces, Gradients, Charts, Segments, Banners, and more.

### Typography — `ADIBTypography`

13 font styles (SF Pro): largeTitle, h1–h4, body, caption with regular/semibold/heavy weights.

```swift
Text("Hello")
    .adibTextStyle(ADIBTypography.h1.semibold)
```

### Spacing — `ADIBSpacing`

```swift
VStack { ... }
    .adibScreenPadding() // 20pt horizontal
```
