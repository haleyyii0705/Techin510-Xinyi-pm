//
//  Moomo_Widget.swift
//  Moomo Widget
//
//  Created by 邵林峥嵘 on 2025/6/6.
//

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

struct Mood: Identifiable {
    let id = UUID()
    let imageName: String
}

let moods: [Mood] = [
    Mood(imageName: "Joy"),
    Mood(imageName: "Sadness"),
    Mood(imageName: "Surprise"),
    Mood(imageName: "Disgust"),
    Mood(imageName: "Anger"),
    Mood(imageName: "Fear")
]

struct MoodWidgetEntryView: View {
    var entry: MoodWidgetProvider.Entry
    let itemSize: CGFloat = 45
    let spacing: CGFloat = 25
    let horizontalPadding: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            let itemsPerRow = 3
            let rows = moods.chunked(into: itemsPerRow)
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: spacing) {
                    ForEach(rows.indices, id: \ .self) { rowIndex in
                        HStack(spacing: spacing) {
                            ForEach(rows[rowIndex]) { mood in
                                Image(mood.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: itemSize, height: itemSize)
                            }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [self] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

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

#Preview(as: .systemSmall) {
    MoomoWidget()
} timeline: {
    MoodWidgetEntry(date: .now)
}
