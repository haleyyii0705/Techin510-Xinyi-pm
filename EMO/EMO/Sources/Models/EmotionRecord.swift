import Foundation

struct EmotionRecord: Identifiable, Codable {
    let id: UUID
    let mood: Mood
    let note: String
    let timestamp: Date
    
    init(id: UUID = UUID(), mood: Mood, note: String, timestamp: Date = Date()) {
        self.id = id
        self.mood = mood
        self.note = note
        self.timestamp = timestamp
    }
}

// Extension of Mood enum to support Codable
extension Mood: Codable {
    enum CodingKeys: String, CodingKey {
        case rawValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        guard let mood = Mood(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(forKey: .rawValue, in: container, debugDescription: "Invalid mood value")
        }
        self = mood
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .rawValue)
    }
} 