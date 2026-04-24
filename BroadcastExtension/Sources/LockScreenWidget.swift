import WidgetKit
import SwiftUI

struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LockScreenProvider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Lock Screen")
        .description("Lock Screen Widget")
    }
}

struct LockScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> LockScreenEntry {
        LockScreenEntry(date: Date(), items: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LockScreenEntry) -> Void) {
        let entry = LockScreenEntry(date: Date(), items: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenEntry>) -> Void) {
        let entry = LockScreenEntry(date: Date(), items: [])
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct LockScreenEntry: TimelineEntry {
    let date: Date
    let items: [WidgetItem]
}

struct LockScreenWidgetEntryView: View {
    var entry: LockScreenEntry
    
    var body: some View {
        ZStack {
            Color.black
            
            if entry.items.isEmpty {
                Image(systemName: "star.fill")
                    .font(.largeTitle)
            } else if let item = entry.items.first {
                if item.displayType == .icon {
                    Image(systemName: item.sfSymbolName)
                        .font(.title2)
                } else {
                    Text(item.customText)
                        .font(.caption)
                }
            }
        }
    }
}
