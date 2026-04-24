import WidgetKit
import SwiftUI

struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LockScreenProvider()) { entry in
            LockScreenWidgetView(entry: entry)
                .background(Color.black)
        }
        .configurationDisplayName("Lock Screen Widget")
        .description("Customizable widget for Lock Screen")
        .supportedFamilies([.accessoryInline, .accessoryCircular])
    }
}

struct LockScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> LockScreenEntry {
        LockScreenEntry(date: Date(),items: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LockScreenEntry) -> Void) {
        let entry = LockScreenEntry(date: Date(), items: loadItems())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenEntry>) -> Void) {
        let entry = LockScreenEntry(date: Date(), items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func loadItems() -> [WidgetItem] {
        let userDefaults = UserDefaults(suiteName: "group.com.iosmirror")
        guard let data = userDefaults?.data(forKey: "widget_configurations"),
              let configurations = try? JSONDecoder().decode([WidgetConfiguration].self, from: data),
              let config = configurations.first else {
            return []
        }
        return config.items
    }
}

struct LockScreenEntry: TimelineEntry {
    let date: Date
    let items: [WidgetItem]
}

struct LockScreenWidgetView: View {
    var entry: LockScreenEntry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .accessoryInline:
            inlineView
        case .accessoryCircular:
            circularView
        case .accessoryRectangular:
            rectangularView
        case .systemMedium:
            mediumView
        default:
            rectangularView
        }
    }
    
    // MARK: - Inline View
    
    private var inlineView: some View {
        HStack(spacing: 4) {
            ForEach(entry.items.prefix(2)) { item in
                if item.displayType == .icon {
                    Image(systemName: item.sfSymbolName)
                } else {
                    Text(item.customText)
                }
            }
        }
    }
    
    // MARK: - Circular View
    
    private var circularView: some View {
        ZStack {
            if let item = entry.items.first {
                if item.displayType == .icon {
                    Image(systemName: item.sfSymbolName)
                } else {
                    Text(String(item.customText.prefix(1)))
                        .font(.headline)
                }
            } else {
                Image(systemName: "star.fill")
            }
        }
    }
    
    // MARK: - Rectangular View
    
    private var rectangularView: some View {
        HStack(spacing: 8) {
            ForEach(entry.items.prefix(6)) { item in
                if item.displayType == .icon {
                    Image(systemName: item.sfSymbolName)
                } else {
                    Text(item.customText)
                        .lineLimit(1)
                }
            }
        }
    }
    
    // MARK: - Medium View
    
    private var mediumView: some View {
        HStack(spacing: 8) {
            ForEach(entry.items.prefix(6)) { item in
                if item.displayType == .icon {
                    Image(systemName: item.sfSymbolName)
                        .font(.title2)
                } else {
                    Text(item.customText)
                        .font(.title3)
                        .lineLimit(1)
                }
            }
        }
    }
}