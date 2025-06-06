import SwiftUI

struct EditEmotionView: View {
    let emotion: EmotionType
    let date: Date
    var onDismiss: () -> Void

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
                .onTapGesture { isFocused = false }

            VStack(spacing: 0) {
                // 顶部栏
                HStack {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(date, formatter: dateFormatter)
                        .font(.custom("Poppins", size: 16).weight(.bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        MoodDataManager.shared.addRecord(emotion: emotion, content: text)
                        onDismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .frame(height: 44)

                // 情绪大图
                Image(emotion.iconName)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.top, 16)

                // 情绪名称和横线
                VStack(spacing: 8) {
                    Text(emotion.rawValue)
                        .font(.custom("Poppins", size: 20).weight(.bold))
                        .foregroundColor(.black)
                    RoundedRectangle(cornerRadius: 3.5)
                        .fill(emotion.color)
                        .frame(width: 90, height: 7)
                }
                .padding(.top, 8)

                // 输入区域（无边框无背景，直接在Joy下方，紧凑布局）
                TextEditor(text: $text)
                    .frame(height: 60)
                    .padding(.horizontal, 36)
                    .background(Color.clear)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .padding(.top, 8)

                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy MMMM d"
    return f
}() 