import SwiftUI

struct EmotionRecordView: View {
    @State private var selectedMood: Mood = .neutral
    @State private var note: String = ""
    
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
        }
    }
    
    private func saveRecord() {
        // TODO: Implement save record logic
        print("Saving mood record: \(selectedMood), note: \(note)")
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

enum Mood: String, CaseIterable, Identifiable {
    case veryHappy = "Very Happy"
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    case verySad = "Very Sad"
    
    var id: String { self.rawValue }
    
    var description: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .veryHappy: return "face.smiling.fill"
        case .happy: return "face.smiling"
        case .neutral: return "face.neutral"
        case .sad: return "face.frown"
        case .verySad: return "face.frown.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .veryHappy: return .yellow
        case .happy: return .green
        case .neutral: return .blue
        case .sad: return .orange
        case .verySad: return .red
        }
    }
}

struct EmotionRecordView_Previews: PreviewProvider {
    static var previews: some View {
        EmotionRecordView()
    }
} 