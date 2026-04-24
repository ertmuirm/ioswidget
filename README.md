# Widget iOS App

Customizable iOS widgets for Home Screen, Lock Screen, and Control Center.

## App Features

- **Home Screen Widgets**: Support for 1×1, 3×3, 6×3, and 6×6 layouts
- **Lock Screen Widgets**: Support for accessoryInline, accessoryCircular, accessoryRectangular, and systemMedium families
- **Customizable Items**: Add icons (SF Symbols) or custom text to widgets
- **Color Customization**: Foreground color, background color, and transparency controls
- **Actions**: Support for URL Schemes, App Intents, and Shortcuts
- **Data Persistence**: Shared storage via App Groups for widget/app data exchange
- **Backup/Restore**: Export and import widget configurations

## Project Structure

```
Widget/
├── Sources/
│   ├── App/          # Main app entry point
│   ├── Models/       # Data models (WidgetItem, WidgetConfiguration, etc.)
│   ├── Views/       # SwiftUI views
│   ├── ViewModels/  # MVVM view models
│   ├── Services/   # Action executor service
│   └── Intents/   # App Intents definitions
├── Resources/
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── Widget.entitlements

BroadcastExtension/
├── Sources/
│   ├── HomeScreenWidget.swift
│   ├── LockScreenWidget.swift
│   └── BroadcastWidgetBundle.swift
└── Info.plist
```

## Building

### Prerequisites

- macOS with Xcode 15.0+
- XcodeGen installed (`brew install xcodegen`)

### Build Steps

1. Generate Xcode project:
   ```bash
   xcodegen generate
   ```

2. Open in Xcode:
   ```bash
   open Widget.xcodeproj
   ```

3. Build and run on simulator or device

## For SideStore Installation (Unsigned)

The GitHub Actions workflow produces:
- `Widget-SideStore.zip` containing the unsigned IPA
- Import via SideStore app

## Bundle Identifiers

- Main App: `com.iosmirror`
- Widget Extension: `com.iosmirror.broadcast`
- App Group: `group.com.iosmirror`

## URL Scheme

- Custom URL: `widgetapp://`

## Technical Details

- **Minimum iOS**: 17.0
- **UI Framework**: SwiftUI
- **Widget Framework**: WidgetKit
- **Intents**: App Intents framework
- **Architecture**: MVVM

## License

MIT
