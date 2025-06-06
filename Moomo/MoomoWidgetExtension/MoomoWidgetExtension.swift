import WidgetKit
import SwiftUI

struct MoodWidgetEntry: TimelineEntry {
    let date: Date
}

struct MoodWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MoodWidgetEntry {
        MoodWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MoodWidgetEntry) -> ()) {
        let entry = MoodWidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MoodWidgetEntry>) -> ()) {
        let entry = MoodWidgetEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct MoodWidgetEntryView: View {
    var entry: MoodWidgetProvider.Entry

    var body: some View {
        MoodWidgetView() // 直接用你写好的主视图
    }
}

@main
struct MoomoWidget: Widget {
    let kind: String = "MoomoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MoodWidgetProvider()) { entry in
            MoodWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Moomo 情绪小组件")
        .description("快速记录你的心情。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
} 