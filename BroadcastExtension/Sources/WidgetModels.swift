import Foundation
import SwiftUI
import WidgetKit

// MARK: - Widget Item Model

struct WidgetItem: Identifiable, Codable, Equatable {
    let id: UUID
    var displayType: DisplayType
    var sfSymbolName: String
    var customText: String
    var fontSize: Int
    var foregroundColor: CodableColor
    var backgroundColor: CodableColor
    var backgroundTransparency: Double
    var actionType: ActionType
    var actionPayload: String
    
    init(
        id: UUID = UUID(),
        displayType: DisplayType = .icon,
        sfSymbolName: String = "star.fill",
        customText: String = "",
        fontSize: Int = 12,
        foregroundColor: CodableColor = CodableColor(red: 1, green: 1, blue: 1, opacity: 1),
        backgroundColor: CodableColor = CodableColor(red: 0, green: 0, blue: 0, opacity: 1),
        backgroundTransparency: Double = 0.0,
        actionType: ActionType = .urlScheme,
        actionPayload: String = ""
    ) {
        self.id = id
        self.displayType = displayType
        self.sfSymbolName = sfSymbolName
        self.customText = customText
        self.fontSize = fontSize
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.backgroundTransparency = backgroundTransparency
        self.actionType = actionType
        self.actionPayload = actionPayload
    }
    
    static func == (lhs: WidgetItem, rhs: WidgetItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Display Type

enum DisplayType: String, Codable, CaseIterable {
    case icon
    case text
}

// MARK: - Action Type

enum ActionType: String, Codable, CaseIterable {
    case urlScheme = "URL Scheme"
    case appIntent = "App Intent"
    case shortcut = "Shortcut"
}

// MARK: - Codable Color

struct CodableColor: Codable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double
    
    init(color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
    }
    
    init(red: Double = 0, green: Double = 0, blue: Double = 0, opacity: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }
    
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: opacity)
    }
}

// MARK: - Widget Configuration

struct WidgetConfiguration: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var homeScreenSize: HomeScreenSize
    var itemCapacity: Int
    var items: [WidgetItem]
    var backgroundColor: CodableColor
    var backgroundTransparency: Double
    
    init(
        id: UUID = UUID(),
        name: String = "New Widget",
        homeScreenSize: HomeScreenSize = .small,
        itemCapacity: Int = 1,
        items: [WidgetItem] = [],
        backgroundColor: CodableColor = CodableColor(red: 0, green: 0, blue: 0, opacity: 1),
        backgroundTransparency: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.homeScreenSize = homeScreenSize
        self.itemCapacity = itemCapacity
        self.items = items
        self.backgroundColor = backgroundColor
        self.backgroundTransparency = backgroundTransparency
    }
    
    static func == (lhs: WidgetConfiguration, rhs: WidgetConfiguration) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Home Screen Size

enum HomeScreenSize: String, Codable, CaseIterable {
    case small = "1×1"
    case medium = "3×3"
    case large = "6×3"
    case extraLarge = "6×6"
    
    var itemCapacity: Int {
        switch self {
        case .small: return 1
        case .medium: return 9
        case .large: return 18
        case .extraLarge: return 36
        }
    }
    
    var dimensions: String {
        switch self {
        case .small: return "1×1"
        case .medium: return "3×3"
        case .large: return "6×3"
        case .extraLarge: return "6×6"
        }
    }
}

// MARK: - Lock Screen Type

enum LockScreenType: String, Codable, CaseIterable {
    case accessoryInline
    case accessoryCircular
    case accessoryRectangular
    case systemMedium
    
    var maxItems: Int {
        switch self {
        case .accessoryInline: return 2
        case .accessoryCircular: return 1
        case .accessoryRectangular: return 6
        case .systemMedium: return 6
        }
    }
}

// MARK: - App Intent Model

struct AppIntentInfo: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var identifier: String
    var appName: String
    var appBundleId: String
    
    init(
        id: UUID = UUID(),
        name: String,
        identifier: String,
        appName: String,
        appBundleId: String
    ) {
        self.id = id
        self.name = name
        self.identifier = identifier
        self.appName = appName
        self.appBundleId = appBundleId
    }
}

// MARK: - Shortcut Info

struct ShortcutInfo: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var identifier: String
    
    init(
        id: UUID = UUID(),
        name: String,
        identifier: String
    ) {
        self.id = id
        self.name = name
        self.identifier = identifier
    }
}