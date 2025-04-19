import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Emotion status card
                EmotionStatusCard()
                
                // Today's mood
                TodayMoodView()
                
                // Recent records
                RecentRecordsView()
            }
            .padding()
            .navigationTitle("Emotion Tracker")
        }
    }
}

struct EmotionStatusCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Current Emotion")
                .font(.headline)
            
            HStack {
                Image(systemName: "face.smiling.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                
                VStack(alignment: .leading) {
                    Text("Feeling Good")
                        .font(.title2)
                    Text("Keep it up!")
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
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Today's Mood")
                .font(.headline)
            
            // Mood picker will be added here
            Text("Tap to record today's mood")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct RecentRecordsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Records")
                .font(.headline)
            
            // Recent records list will be added here
            Text("No records yet")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 