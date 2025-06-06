import SwiftUI

struct Mood: Identifiable {
    let id = UUID()
    let imageName: String
}

let moods: [Mood] = [
    Mood(imageName: "Surprise"),
    Mood(imageName: "Joy"),
    Mood(imageName: "Sadness"),
    Mood(imageName: "Disgust"),
    Mood(imageName: "Anger"),
    Mood(imageName: "Fear")
]

struct MoodWidgetView: View {
    // 自动适配屏幕宽度，单行/多行自适应
    let itemSize: CGFloat = 45
    let spacing: CGFloat = 25
    let horizontalPadding: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - horizontalPadding * 2
            let itemsPerRow = max(1, Int((availableWidth + spacing) / (itemSize + spacing)))
            let rows = moods.chunked(into: itemsPerRow)
            ZStack {
                Color(hex: "#FEFBFF").ignoresSafeArea()
                VStack(spacing: spacing) {
                    ForEach(rows.indices, id: \ .self) { rowIndex in
                        HStack(spacing: spacing) {
                            ForEach(rows[rowIndex]) { mood in
                                Button(action: {
                                    print("添加心情：\(mood.imageName)")
                                }) {
                                    Image(mood.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: itemSize, height: itemSize)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 10)
            }
        }
        .frame(minHeight: 70)
    }
}

// 数组分组扩展
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [self] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// 预览
struct MoodWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MoodWidgetView()
                .previewLayout(.fixed(width: 400, height: 120))
            MoodWidgetView()
                .previewLayout(.fixed(width: 200, height: 120))
        }
    }
} 