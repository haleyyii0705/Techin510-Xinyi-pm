import Foundation

class EmotionDataService {
    static let shared = EmotionDataService()
    private let userDefaults = UserDefaults.standard
    private let recordsKey = "emotionRecords"
    
    private init() {}
    
    func saveRecord(_ record: EmotionRecord) {
        var records = getAllRecords()
        records.append(record)
        
        if let encoded = try? JSONEncoder().encode(records) {
            userDefaults.set(encoded, forKey: recordsKey)
        }
    }
    
    func getAllRecords() -> [EmotionRecord] {
        guard let data = userDefaults.data(forKey: recordsKey),
              let records = try? JSONDecoder().decode([EmotionRecord].self, from: data) else {
            return []
        }
        return records.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getRecentRecords(limit: Int = 5) -> [EmotionRecord] {
        return Array(getAllRecords().prefix(limit))
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
} 