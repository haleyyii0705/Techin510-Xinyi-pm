import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var emotionService = EmotionDataService.shared
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Emotion Trend")) {
                    EmotionTrendChart(records: emotionService.getAllRecords())
                }
                
                Section(header: Text("Emotion Distribution")) {
                    EmotionDistributionChart(distribution: emotionService.getMoodDistribution())
                }
                
                Section(header: Text("Statistics Summary")) {
                    StatisticsSummary(
                        totalRecords: emotionService.getAllRecords().count,
                        averageMood: emotionService.getAverageMood()?.description ?? "No data",
                        mostCommonMood: emotionService.getMoodDistribution()
                            .max(by: { $0.value < $1.value })?.key.description ?? "No data"
                    )
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

struct EmotionTrendChart: View {
    let records: [EmotionRecord]
    
    var body: some View {
        if records.isEmpty {
            Text("No data available")
                .foregroundColor(.gray)
                .frame(height: 200)
        } else {
            Chart {
                ForEach(records) { record in
                    LineMark(
                        x: .value("Date", record.timestamp),
                        y: .value("Mood", moodValue(record.mood))
                    )
                    .foregroundStyle(record.mood.color)
                }
            }
            .frame(height: 200)
        }
    }
    
    private func moodValue(_ mood: Mood) -> Int {
        switch mood {
        case .veryHappy: return 5
        case .happy: return 4
        case .neutral: return 3
        case .sad: return 2
        case .verySad: return 1
        }
    }
}

struct EmotionDistributionChart: View {
    let distribution: [Mood: Int]
    
    var body: some View {
        if distribution.isEmpty {
            Text("No data available")
                .foregroundColor(.gray)
                .frame(height: 200)
        } else {
            Chart {
                ForEach(Mood.allCases) { mood in
                    BarMark(
                        x: .value("Mood", mood.description),
                        y: .value("Count", distribution[mood] ?? 0)
                    )
                    .foregroundStyle(mood.color)
                }
            }
            .frame(height: 200)
        }
    }
}

struct StatisticsSummary: View {
    let totalRecords: Int
    let averageMood: String
    let mostCommonMood: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            StatRow(title: "Total Records", value: "\(totalRecords)")
            StatRow(title: "Average Mood", value: averageMood)
            StatRow(title: "Most Common Mood", value: mostCommonMood)
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
} 