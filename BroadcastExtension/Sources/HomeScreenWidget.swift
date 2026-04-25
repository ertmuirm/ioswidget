import WidgetKit
import SwiftUI

struct HomeScreenWidget: Widget {
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Widget")
        .description("Home Screen Widget")
    }

    struct Provider: TimelineProvider {
        func placeholder(in context: Context) -> Entry {
            Entry(date: Date())
        }

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(Entry(date: Date()))
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
                VStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.largeTitle)
                    Text("Widget")
                        .font(.caption2)
                }
                .foregroundColor(.white)
            }
        }
    }
}
