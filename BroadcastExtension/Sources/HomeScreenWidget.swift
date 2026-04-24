import WidgetKit
import SwiftUI

struct HomeScreenWidget: Widget {
    let kind: String = "BroadcastWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HomeScreenProvider()) { entry in
            HomeScreenWidgetView(entry: entry)
                .background(Color.black)
        }
        .configurationDisplayName("Widget")
        .description("Customizable widget for Home Screen")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct HomeScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> HomeScreenEntry {
        HomeScreenEntry(date: Date(), configuration: nil, items: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HomeScreenEntry) -> Void) {
        let entry = HomeScreenEntry(date: Date(), configuration: loadConfiguration(), items: loadItems())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HomeScreenEntry>) -> Void) {
        let entry = HomeScreenEntry(date: Date(), configuration: loadConfiguration(), items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func loadConfiguration() -> WidgetConfiguration? {
        let userDefaults = UserDefaults(suiteName: "group.com.iosmirror")
        guard let data = userDefaults?.data(forKey: "widget_configurations"),
              let configurations = try? JSONDecoder().decode([WidgetConfiguration].self, from: data) else {
            return nil
        }
        return configurations.first
    }
    
    private func loadItems() -> [WidgetItem] {
        guard let config = loadConfiguration() else { return [] }
        return config.items
    }
}

struct HomeScreenEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetConfiguration?
    let items: [WidgetItem]
}

struct HomeScreenWidgetView: View {
    var entry: HomeScreenEntry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        if let configuration = entry.configuration {
            ZStack {
                Color.black
                    .opacity(1.0 - configuration.backgroundTransparency)
                
                widgetContent(configuration)
            }
        } else {
            emptyWidgetView
        }
    }
    
    @ViewBuilder
    private func widgetContent(_ configuration: WidgetConfiguration) -> some View {
        switch widgetFamily {
        case .systemSmall:
            smallWidget(configuration)
        case .systemMedium:
            mediumWidget(configuration)
        case .systemLarge:
            largeWidget(configuration)
        case .systemExtraLarge:
            extraLargeWidget(configuration)
        default:
            mediumWidget(configuration)
        }
    }
    
    // MARK: - Small Widget (1x1)
    
    private func smallWidget(_ config: WidgetConfiguration) -> some View {
        if let item = config.items.first {
            return AnyView(itemView(item: item))
        } else {
            return AnyView(emptyWidgetView)
        }
    }
    
    // MARK: - Medium Widget (3x3)
    
    private func mediumWidget(_ config: WidgetConfiguration) -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(config.items.prefix(9)) { item in
                itemView(item: item)
            }
        }
        .padding(8)
    }
    
    // MARK: - Large Widget (6x3)
    
    private func largeWidget(_ config: WidgetConfiguration) -> some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 6)
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(config.items.prefix(18)) { item in
                itemView(item: item)
            }
        }
        .padding(8)
    }
    
    // MARK: - Extra Large Widget (6x6)
    
    private func extraLargeWidget(_ config: WidgetConfiguration) -> some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 6)
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(config.items.prefix(36)) { item in
                itemView(item: item)
            }
        }
        .padding(8)
    }
    
    // MARK: - Item View
    
    @ViewBuilder
    private func itemView(item: WidgetItem) -> some View {
        Link(destination: URL(string: "widgetapp://action/\(item.id.uuidString)")!) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(item.backgroundColor.color.opacity(1.0 - item.backgroundTransparency))
                
                if item.displayType == .icon {
                    Image(systemName: item.sfSymbolName)
                        .font(.system(size: CGFloat(item.fontSize)))
                        .foregroundColor(item.foregroundColor.color)
                } else {
                    Text(item.customText)
                        .font(.system(size: CGFloat(item.fontSize)))
                        .foregroundColor(item.foregroundColor.color)
                        .lineLimit(1)
                }
            }
        }
    }
    
    // MARK: - Empty Widget
    
    private var emptyWidgetView: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.grid.2x2")
                .font(.largeTitle)
            Text("No Widget")
                .font(.caption)
        }
        .foregroundColor(.white)
    }
}