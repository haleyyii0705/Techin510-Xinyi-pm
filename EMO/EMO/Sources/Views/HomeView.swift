import SwiftUI

struct HomeView: View {
    @StateObject private var emotionService = EmotionDataService.shared
    @State private var showingMoodPicker = false
    @State private var selectedMood: Mood = Mood.neutral
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Emotion status card
                EmotionStatusCard(currentMood: emotionService.getCurrentMood())
                
                // Today's mood
                TodayMoodView(selectedMood: $selectedMood, showingMoodPicker: $showingMoodPicker)
                    .onTapGesture {
                        showingMoodPicker = true
                    }
                
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
