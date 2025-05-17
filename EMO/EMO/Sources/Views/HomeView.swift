import SwiftUI
import Foundation

struct HomeView: View {
    @StateObject private var emotionService = EmotionDataService.shared
    @State private var showingMoodPicker = false
    @State private var selectedMood: Mood = Mood.neutral
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                CalendarView()
                // Recent records
                RecentRecordsView(records: emotionService.getRecentRecords())
            }
            .padding()
            .navigationTitle("Emotion Tracker")
            .sheet(isPresented: $showingMoodPicker) {
                MoodPickerSheet(selectedMood: $selectedMood, showingMoodPicker: $showingMoodPicker) { mood in
                    emotionService.saveEmotion(mood: mood)
                }
            }
        }
    }
}

struct EmotionStatusCard: View {
    let currentMood: Mood?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Emotion")
                .font(.headline)
            
            HStack {
                Image(systemName: currentMood?.icon ?? "face.smiling.fill")
                    .font(.system(size: 40))
                    .foregroundColor(currentMood?.color ?? .yellow)
                
                VStack(alignment: .leading) {
                    Text(currentMood?.description ?? "No mood recorded")
                        .font(.title2)
                    Text(currentMood != nil ? "Keep it up!" : "Record your mood")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct TodayMoodView: View {
    @Binding var selectedMood: Mood
    @Binding var showingMoodPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today's Mood")
                .font(.headline)
            
            HStack {
                Image(systemName: selectedMood.icon)
                    .foregroundColor(selectedMood.color)
                Text(selectedMood.description)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct RecentRecordsView: View {
    let records: [EmotionRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Records")
                .font(.headline)
            
            if records.isEmpty {
                Text("No records yet")
                    .foregroundColor(.gray)
            } else {
                ForEach(records) { record in
                    HStack {
                        Image(systemName: record.mood.icon)
                            .foregroundColor(record.mood.color)
                        Text(record.mood.description)
                        Spacer()
                        Text(record.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct MoodPickerSheet: View {
    @Binding var selectedMood: Mood
    @Binding var showingMoodPicker: Bool
    let onSave: (Mood) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Mood", selection: $selectedMood) {
                    ForEach(Mood.allCases) { mood in
                        HStack {
                            Image(systemName: mood.icon)
                                .foregroundColor(mood.color)
                            Text(mood.description)
                        }
                        .tag(mood)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Button("Save") {
                    onSave(selectedMood)
                    showingMoodPicker = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("Select Your Mood")
            .navigationBarItems(trailing: Button("Cancel") {
                showingMoodPicker = false
            })
        }
    }
}

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let mood: Mood?
}

struct CalendarView: View {
    @ObservedObject var emotionService = EmotionDataService.shared
    @State private var selectedDate: Date? = nil
    @State private var showingMoodPicker = false
    @State private var selectedMood: Mood = .neutral
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["一", "二", "三", "四", "五", "六", "日"]
    
    var body: some View {
        VStack(spacing: 8) {
            // 月份标题
            Text(currentMonthTitle())
                .font(.title2)
                .bold()
                .padding(.bottom, 4)
            // 周标题
            HStack {
                ForEach(daysOfWeek, id: \ .self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }
            // 日期格子
            let days = generateDaysForMonth()
            let rows = days.chunked(into: 7)
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack {
                    ForEach(rows[rowIndex]) { day in
                        Button(action: {
                            selectedDate = day.date
                            selectedMood = day.mood ?? .neutral
                            showingMoodPicker = true
                        }) {
                            VStack(spacing: 2) {
                                Text("\(calendar.component(.day, from: day.date))")
                                    .font(.body)
                                    .foregroundColor(isToday(day.date) ? .blue : .primary)
                                if let mood = day.mood {
                                    Image(systemName: mood.icon)
                                        .foregroundColor(mood.color)
                                        .font(.caption)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 36)
                            .background(isToday(day.date) ? Color.blue.opacity(0.15) : Color.clear)
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .sheet(isPresented: $showingMoodPicker) {
            NavigationView {
                VStack {
                    Picker("选择心情", selection: $selectedMood) {
                        ForEach(Mood.allCases) { mood in
                            HStack {
                                Image(systemName: mood.icon)
                                    .foregroundColor(mood.color)
                                Text(mood.description)
                            }
                            .tag(mood)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding()

                    Button("保存") {
                        if let date = selectedDate {
                            saveMood(selectedMood, for: date)
                        }
                        showingMoodPicker = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .navigationTitle("选择心情")
                .navigationBarItems(trailing: Button("取消") {
                    showingMoodPicker = false
                })
            }
        }
    }
    
    func currentMonthTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: Date())
    }
    
    func generateDaysForMonth() -> [CalendarDay] {
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        let components = calendar.dateComponents([.year, .month], from: today)
        let firstOfMonth = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingEmpty = (weekday + 5) % 7 // 让周一为第一天
        var days: [CalendarDay] = []
        // 补空格
        for _ in 0..<leadingEmpty {
            days.append(CalendarDay(date: Date.distantPast, mood: nil))
        }
        // 本月天数
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                let mood = emotionService.records.first(where: { calendar.isDate($0.timestamp, inSameDayAs: date) })?.mood
                days.append(CalendarDay(date: date, mood: mood))
            }
        }
        // 补尾部空格
        while days.count % 7 != 0 {
            days.append(CalendarDay(date: Date.distantFuture, mood: nil))
        }
        return days
    }
    
    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    func saveMood(_ mood: Mood, for date: Date) {
        emotionService.saveEmotion(mood: mood, for: date)
    }
}

// chunked工具
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
