import Foundation
import Combine

class EmotionDataService: ObservableObject {
    static let shared = EmotionDataService()
    private let userDefaults = UserDefaults.standard
    private let recordsKey = "emotionRecords"
    private let currentMoodKey = "currentMood"
    
    @Published var records: [EmotionRecord] = []
    
    private init() {
        self.records = getAllRecords()
    }
    
    func saveEmotion(mood: Mood) {
        let record = EmotionRecord(mood: mood, note: "")
        saveRecord(record)
        userDefaults.set(mood.rawValue, forKey: currentMoodKey)
    }
    
    func getCurrentMood() -> Mood? {
        guard let moodString = userDefaults.string(forKey: currentMoodKey) else {
            return nil
        }
        return Mood(rawValue: moodString)
    }
    
    func saveRecord(_ record: EmotionRecord) {
        var allRecords = getAllRecords()
        allRecords.append(record)
        if let encoded = try? JSONEncoder().encode(allRecords) {
            userDefaults.set(encoded, forKey: recordsKey)
        }
        self.records = allRecords.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getAllRecords() -> [EmotionRecord] {
        guard let data = userDefaults.data(forKey: recordsKey),
              let records = try? JSONDecoder().decode([EmotionRecord].self, from: data) else {
            return []
        }
        return records.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getRecentRecords(limit: Int = 5) -> [EmotionRecord] {
        return Array(records.prefix(limit))
    }
    
    func getRecordsByDateRange(from: Date, to: Date) -> [EmotionRecord] {
        return getAllRecords().filter { record in
            record.timestamp >= from && record.timestamp <= to
        }
    }
    
    func getMoodDistribution() -> [Mood: Int] {
        let records = getAllRecords()
        var distribution: [Mood: Int] = [:]
        
        for mood in Mood.allCases {
            distribution[mood] = records.filter { $0.mood == mood }.count
        }
        
        return distribution
    }
    
    func getAverageMood() -> Mood? {
        let records = getAllRecords()
        guard !records.isEmpty else { return nil }
        
        let moodValues = records.map { mood in
            switch mood.mood {
            case .veryHappy: return 5
            case .happy: return 4
            case .neutral: return 3
            case .sad: return 2
            case .verySad: return 1
            }
        }
        
        let average = Double(moodValues.reduce(0, +)) / Double(moodValues.count)
        
        switch average {
        case 4.5...: return .veryHappy
        case 3.5..<4.5: return .happy
        case 2.5..<3.5: return .neutral
        case 1.5..<2.5: return .sad
        default: return .verySad
        }
    }
    
    func saveEmotion(mood: Mood, for date: Date) {
        var allRecords = getAllRecords()
        if let idx = allRecords.firstIndex(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }) {
            let old = allRecords[idx]
            allRecords[idx] = EmotionRecord(id: old.id, mood: mood, note: old.note, timestamp: date)
        } else {
            let record = EmotionRecord(mood: mood, note: "", timestamp: date)
            allRecords.append(record)
        }
        if let encoded = try? JSONEncoder().encode(allRecords) {
            userDefaults.set(encoded, forKey: recordsKey)
        }
        self.records = allRecords.sorted { $0.timestamp > $1.timestamp }
    }
} 