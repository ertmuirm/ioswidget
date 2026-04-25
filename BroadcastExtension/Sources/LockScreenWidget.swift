import WidgetKit
import SwiftUI

struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Lock Screen")
        .description("Lock Screen Widget")
    }
    
    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> Entry {
            Entry(date: Date())
        }
        
        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            let entry = Entry(date: Date())
            completion(entry)
        }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            let entry = Entry(date: Date())
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
    }
    
    struct Entry: TimelineEntry {
        let date: Date
    }
    
    struct WidgetEntryView: View {
        let entry: Entry
        
        var body: some View {
            ZStack {
                Color.black
                Image(systemName: "star.fill")
                    .font(.title2)
            }
        }
    }
}
