# ADIBUIKit

A SwiftUI component library for the ADIB design system.

## Installation

Add this package via Swift Package Manager:

```
https://github.com/elJagal/ADIBUIKit.git
```

## Components

### PrimaryButton

A primary action button with three sizes and four states.

```swift
import ADIBUIKit

// Default
PrimaryButton("Done") {
    print("Tapped")
}

// With size
PrimaryButton("Done", size: .medium) {
    print("Tapped")
}

// Loading state
PrimaryButton("Done", isLoading: true) {}

// Disabled
PrimaryButton("Done") {}
    .disabled(true)
```

#### Sizes
| Size | Width |
|------|-------|
| `.small` | 258pt |
| `.medium` | 319pt |
| `.large` | 386pt |

#### States
- **Default** — `#003978` background
- **Tapped** — `#6284AA` background
- **Disabled** — `#C4CFDC` background
- **Loading** — Animated dots

> **Font:** Uses the iOS system font (SF Pro) with medium weight.
