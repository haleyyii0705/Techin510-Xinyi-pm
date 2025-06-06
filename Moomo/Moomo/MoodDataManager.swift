import Foundation
import SwiftUI

struct MoodRecord: Codable, Identifiable {
    let id: UUID
    let dateTime: Date
    let emotion: EmotionType
    let content: String

    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dateTime)
    }
}

class MoodDataManager: ObservableObject {
    static let shared = MoodDataManager()
    @Published var records: [MoodRecord] = []

    let fileURL: URL = {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return doc.appendingPathComponent("mood_records.json")
    }()

    init() {
        load()
    }

    func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([MoodRecord].self, from: data) {
            records = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(records) {
            try? data.write(to: fileURL)
        }
    }

    func addRecord(emotion: EmotionType, content: String) {
        let record = MoodRecord(id: UUID(), dateTime: Date(), emotion: emotion, content: content)
        records.append(record)
        save()
    }

    // 获取某天最新的记录
    func latestRecord(for date: Date) -> MoodRecord? {
        return records
            .filter { Calendar.current.isDate($0.dateTime, inSameDayAs: date) }
            .sorted { $0.dateTime > $1.dateTime }
            .first
    }

    static func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func generateMockData() {
        let emotions: [EmotionType] = [.joy, .sadness, .surprise, .disgust, .anger, .fear]
        let contents = [
            // Story 1: Joy
            "Today was my first day at a new job. I felt so excited and happy to meet so many friendly colleagues.",
            // Story 2: Surprise
            "During lunch break, I received an unexpected gift. It was such a surprise—my friend remembered my little habits!",
            // Story 3: Fear
            "In the afternoon, I was suddenly called on to speak at a meeting. I was nervous and a bit scared, but I managed to get through it.",
            // Story 4: Anger
            "On my way home, I got stuck in traffic. Drivers were arguing, and I felt angry and helpless.",
            // Story 5: Sadness
            "After getting home, I found my pet was sick. I felt really sad and worried about its health.",
            // Story 6: Disgust
            "Late at night, I scrolled through my phone and saw some negative news. I felt a bit disgusted and decided to go to bed early."
        ]
        let calendar = Calendar.current
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var allRecords: [MoodRecord] = []
        let startDate = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 6, day: 6))!
        var date = startDate
        while date <= endDate {
            if date > now { break }
            let count = Int.random(in: 3...7)
            for i in 0..<count {
                let randomEmotion = emotions.randomElement()!
                let randomContent = contents.randomElement()!
                // 时间分布在当天不同秒
                let time = calendar.date(byAdding: .second, value: i * 3600 + Int.random(in: 0...3599), to: date)!
                let record = MoodRecord(id: UUID(), dateTime: time, emotion: randomEmotion, content: randomContent)
                allRecords.append(record)
            }
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        // 写入文件
        if let data = try? JSONEncoder().encode(allRecords) {
            let fileURL = MoodDataManager.shared.fileURL
            try? data.write(to: fileURL)
            MoodDataManager.shared.records = allRecords
        }
    }
} 