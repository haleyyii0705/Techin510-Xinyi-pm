import SwiftUI

struct EmotionRecordView: View {
    @StateObject private var emotionService = EmotionDataService.shared
    @State private var selectedMood: Mood = Mood.neutral
    @State private var note: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Mood")) {
                    MoodPicker(selectedMood: $selectedMood)
                }
                
                Section(header: Text("Add Note")) {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: saveRecord) {
                        Text("Save Record")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Record Mood")
            .alert("Record Saved", isPresented: $showingAlert) {
                Button("OK") {
                    note = ""
                    selectedMood = .neutral
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveRecord() {
        let record = EmotionRecord(mood: selectedMood, note: note)
        emotionService.saveRecord(record)
        alertMessage = "Your mood has been recorded successfully!"
        showingAlert = true
    }
}

struct MoodPicker: View {
    @Binding var selectedMood: Mood
    
    var body: some View {
        Picker("Mood", selection: $selectedMood) {
            ForEach(Mood.allCases) { mood in
                HStack {
                    Image(systemName: mood.icon)
                        .foregroundColor(mood.color)
                    Text(mood.description)
                }
                .tag(mood)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct EmotionRecordView_Previews: PreviewProvider {
    static var previews: some View {
        EmotionRecordView()
    }
} 