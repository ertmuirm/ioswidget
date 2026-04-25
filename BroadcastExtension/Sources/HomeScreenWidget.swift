import WidgetKit
import SwiftUI

struct HomeScreenWidget: Widget {
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HomeScreenProvider()) { entry in
            HomeScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Widget")
        .description("Home Screen Widget")
    }
}

struct HomeScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> HomeScreenEntry {
        HomeScreenEntry(date: Date(), items: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (HomeScreenEntry) -> Void) {
        completion(HomeScreenEntry(date: Date(), items: []))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HomeScreenEntry>) -> Void) {
        let entry = HomeScreenEntry(date: Date(), items: [])
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct HomeScreenEntry: TimelineEntry {
    let date: Date
    let items: [WidgetItem]
}

struct HomeScreenWidgetEntryView: View {
    var entry: HomeScreenEntry
    
    var body: some View {
        ZStack {
            Color.black
            if entry.items.isEmpty {
                VStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.largeTitle)
                    Text("Widget")
                        .font(.caption2)
                }
                .foregroundColor(.white)
            } else if let item = entry.items.first {
                VStack {
                    if item.displayType == .icon {
                        Image(systemName: item.sfSymbolName)
                            .font(.title2)
                    } else {
                        Text(item.customText)
                            .font(.caption2)
                    }
                }
                .foregroundColor(.white)
            }
        }
    }
}
