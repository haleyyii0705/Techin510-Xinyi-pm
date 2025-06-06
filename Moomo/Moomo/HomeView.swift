import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

enum EmotionType: String, CaseIterable, Identifiable, Codable {
    case joy = "Joy"
    case sadness = "Sadness"
    case surprise = "Surprise"
    case disgust = "Disgust"
    case anger = "Anger"
    case fear = "Fear"
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .joy: return Color(hex: "#FFE26C")
        case .sadness: return Color(hex: "#A0D1E1")
        case .surprise: return Color(hex: "#FFD8DC")
        case .disgust: return Color(hex: "#B4CCBB")
        case .anger: return Color(hex: "#DF6140")
        case .fear: return Color(hex: "#E5BCFF")
        }
    }
    var iconName: String { rawValue }
}

struct WeekView: View {
    @ObservedObject private var moodManager = MoodDataManager.shared
    let calendar = Calendar.current
    @State private var currentWeekStart: Date = WeekView.getThisSunday()
    @Binding var currentDate: Date
    var onDateSelected: (Date) -> Void = { _ in }
    var onMomentSelected: (Date, Date) -> Void = { _,_  in }

    // 获取本周的所有日期（周日到周六）
    var weekDates: [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentWeekStart)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: currentWeekStart) ?? currentWeekStart
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    // 获取某天最多的情绪类型
    func dominantEmotion(for date: Date) -> EmotionType? {
        let records = moodManager.records.filter { calendar.isDate($0.dateTime, inSameDayAs: date) }
        let grouped = Dictionary(grouping: records, by: { $0.emotion })
        return grouped.max(by: { $0.value.count < $1.value.count })?.key
    }

    // 获取某天的记录数
    func recordCount(for date: Date) -> Int {
        moodManager.records.filter { calendar.isDate($0.dateTime, inSameDayAs: date) }.count
    }

    // 获取某天所有记录，按时间排序
    func recordsForDay(_ date: Date) -> [MoodRecord] {
        moodManager.records.filter { calendar.isDate($0.dateTime, inSameDayAs: date) }
            .sorted { $0.dateTime < $1.dateTime }
    }

    // 获取本周最大记录数（决定表情区最大行数）
    var maxRecordCount: Int {
        weekDates.map { recordCount(for: $0) }.max() ?? 0
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            // 顶部时间信息居中
            VStack(spacing: 0) {
                Text(weekYear)
                    .font(Font.custom("Poppins-Regular", size: 10))
                    .foregroundColor(Color(hex: "#939393"))
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(weekMonthTitle)
                    .font(Font.custom("Poppins-Regular", size: 16).weight(.semibold))
                    .kerning(-0.4)
                    .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 24)
            Spacer().frame(height: 24)
            // 日期行左对齐
            let weekAbbr = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            HStack(spacing: 10) {
                ForEach(0..<7, id: \.self) { i in
                    let abbr = weekAbbr[i]
                    let date = weekDates[i]
                    VStack(spacing: 4) {
                        Text(abbr)
                            .font(Font.custom("Poppins-Regular", size: 10).weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.58, green: 0.58, blue: 0.58))
                            .frame(width: 40, height: 13, alignment: .center)
                        Button(action: { onDateSelected(date) }) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(Font.custom("Poppins-Regular", size: 10))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.58, green: 0.58, blue: 0.58))
                                .frame(width: 40, height: 13, alignment: .center)
                        }
                        ZStack {
                            Circle()
                                .stroke(dominantEmotion(for: date)?.color ?? Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1.5)
                                .frame(width: 40, height: 40)
                            Text("\(recordCount(for: date))")
                                .font(Font.custom("Poppins-Regular", size: 14).weight(.medium))
                                .foregroundColor(.black)
                        }
                    }
                    .frame(width: 40, height: 80, alignment: .center)
                }
            }
            .padding(.leading, 34)
            .frame(maxWidth: .infinity, alignment: .leading)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -50 {
                            // 下一周
                            if let nextWeek = calendar.date(byAdding: .day, value: 7, to: currentWeekStart) {
                                currentWeekStart = nextWeek
                            }
                        } else if value.translation.width > 50 {
                            // 上一周
                            if let prevWeek = calendar.date(byAdding: .day, value: -7, to: currentWeekStart) {
                                currentWeekStart = prevWeek
                            }
                        }
                    }
            )
            Spacer().frame(height: 24)
            // 下方表情区左对齐
            ScrollView(.vertical) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(weekDates, id: \.self) { date in
                        VStack(spacing: 12) {
                            ForEach(recordsForDay(date).prefix(maxRecordCount), id: \.id) { record in
                                Button(action: { onMomentSelected(date, record.dateTime) }) {
                                    Image(record.emotion.iconName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                }
                            }
                            ForEach(0..<(maxRecordCount - recordsForDay(date).count), id: \.self) { _ in
                                Spacer().frame(width: 40, height: 40)
                            }
                        }
                    }
                }
                .padding(.leading, 34)
                .padding(.trailing, 34)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
    }

    // 标题格式：2025 May-June 或 2025 June
    var weekTitle: String {
        let first = weekDates.first!
        let last = weekDates.last!
        let year = calendar.component(.year, from: first)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let firstMonth = monthFormatter.string(from: first)
        let lastMonth = monthFormatter.string(from: last)
        if calendar.component(.month, from: first) != calendar.component(.month, from: last) {
            return "\(year) \(firstMonth) - \(lastMonth)"
        } else {
            return "\(year) \(firstMonth)"
        }
    }

    // 获取本周周日
    static func getThisSunday() -> Date {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let offsetToSunday = 1 - weekday
        return calendar.date(byAdding: .day, value: offsetToSunday, to: today)!
    }

    var weekYear: String {
        let first = weekDates.first!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: first)
    }

    var weekMonthTitle: String {
        let first = weekDates.first!
        let last = weekDates.last!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let firstMonth = formatter.string(from: first)
        let lastMonth = formatter.string(from: last)
        if Calendar.current.component(.month, from: first) != Calendar.current.component(.month, from: last) {
            return "\(firstMonth) - \(lastMonth)"
        } else {
            return firstMonth
        }
    }
}

struct DayView: View {
    @ObservedObject private var moodManager = MoodDataManager.shared
    let calendar = Calendar.current
    @Binding var currentDate: Date
    @Binding var scrollToTime: Date?
    @Binding var selectedTab: HomeView.Tab
    @Binding var showPieMask: Bool
    @State private var showTopShadow: Bool = false
    @State private var pieComfortText: String = ""

    // 获取当前天所有记录，按时间排序
    var todayRecords: [MoodRecord] {
        moodManager.records.filter { calendar.isDate($0.dateTime, inSameDayAs: currentDate) }
            .sorted { $0.dateTime < $1.dateTime }
    }

    var body: some View {
        ScrollViewReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                // 顶部时间信息居中
                VStack(spacing: 0) {
                    Text(dayYear)
                        .font(Font.custom("Poppins-Regular", size: 10))
                        .foregroundColor(Color(hex: "#939393"))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(dayMonthAndDay)
                        .font(Font.custom("Poppins-Regular", size: 16).weight(.semibold))
                        .kerning(-0.4)
                        .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 24)
                // 顶部阴影（只在滚动时显示，颜色更轻）
                if showTopShadow {
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                        )
                        .frame(height: 16)
                        .edgesIgnoringSafeArea(.horizontal)
                }
                Spacer().frame(height: 24)
                // 整体左右padding加大
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: OffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    VStack(spacing: 64) {
                        ForEach(todayRecords) { record in
                            VStack(spacing: 8) {
                                Image(record.emotion.iconName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .padding(.top, 0)
                                Text(record.emotion.rawValue.uppercased())
                                    .font(Font.custom("Poppins-Regular", size: 14).weight(.semibold))
                                    .foregroundColor(Color(hex: "#444444"))
                                    .padding(.top, 0)
                                Divider()
                                    .frame(width: 180)
                                    .background(Color.gray.opacity(0.3))
                                Text(timeString(record.dateTime))
                                    .font(Font.custom("Poppins-Regular", size: 12))
                                    .foregroundColor(Color.gray)
                                    .padding(.top, 0)
                                Text(record.content)
                                    .font(Font.custom("Poppins-Regular", size: 12))
                                    .foregroundColor(Color(hex: "#444444"))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 0)
                                    .padding(.horizontal, 44)
                            }
                            .frame(maxWidth: .infinity)
                            .id(record.dateTime)
                        }
                        Spacer().frame(height: 100)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 20)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(OffsetKey.self) { value in
                    showTopShadow = value < -2 // 只要有滚动就显示阴影
                }
            }
            .onChange(of: scrollToTime) { newValue in
                if let time = newValue {
                    withAnimation {
                        proxy.scrollTo(time, anchor: .top)
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -50 {
                            // 下一天
                            if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                                currentDate = nextDay
                            }
                        } else if value.translation.width > 50 {
                            // 左滑切换到Week
                            withAnimation { selectedTab = .week }
                        }
                    }
            )
            Spacer()
        }
    }

    var dayYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: currentDate)
    }

    var dayMonthAndDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: currentDate)
    }

    // 时间格式：18:20
    func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct HomeView: View {
    enum Tab: String, CaseIterable { case month = "Month", week = "Week", day = "Day" }
    @State private var selectedTab: Tab = .month
    @State private var currentDate: Date = Date()
    @State private var scrollToTime: Date? = nil
    @State private var showMask = false
    @State private var editingEmotion: EmotionType? = nil
    @State private var showPieMask = false
    @State private var pieComfortText: String = ""

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                // 顶部Tab栏
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Text(tab.rawValue)
                            .font(Font.custom("Poppins-Regular", size: 12).weight(.medium))
                            .foregroundColor(selectedTab == tab ? Color(hex: "#444444") : Color(hex: "#737373"))
                            .frame(width: 108, height: 33)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedTab == tab ? Color(hex: "#444444") : Color.clear, lineWidth: 1)
                                    .animation(.easeInOut(duration: 0.25), value: selectedTab)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture { withAnimation(.easeInOut(duration: 0.25)) { selectedTab = tab } }
                            .padding(.leading, tab == .month ? 34 : 0)
                            .padding(.trailing, tab == .day ? 34 : 0)
                    }
                }
                .frame(width: 373, height: 49)
                .padding(.top, 20)

                // Tab内容区，支持左右滑动切换
                ZStack {
                    if selectedTab == .month {
                        MonthView(currentDate: $currentDate, onDateSelected: { date in
                            withAnimation {
                                currentDate = date
                                selectedTab = .day
                            }
                        })
                        .transition(.opacity)
                    } else if selectedTab == .week {
                        WeekView(currentDate: $currentDate, onDateSelected: { date in
                            withAnimation {
                                currentDate = date
                                scrollToTime = nil
                                selectedTab = .day
                            }
                        }, onMomentSelected: { date, time in
                            withAnimation {
                                currentDate = date
                                selectedTab = .day
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                scrollToTime = time
                            }
                        })
                        .transition(.opacity)
                    } else if selectedTab == .day {
                        DayView(currentDate: $currentDate, scrollToTime: $scrollToTime, selectedTab: $selectedTab, showPieMask: $showPieMask)
                            .transition(.opacity)
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        if value.translation.width > 50 {
                                            // 左滑切换到Week
                                            withAnimation { selectedTab = .week }
                                        }
                                    }
                            )
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: selectedTab)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                // 右滑
                                if selectedTab == .month {
                                    withAnimation { selectedTab = .week }
                                } else if selectedTab == .week {
                                    withAnimation { selectedTab = .day }
                                }
                            } else if value.translation.width > 50 {
                                // 左滑
                                if selectedTab == .day {
                                    withAnimation { selectedTab = .week }
                                } else if selectedTab == .week {
                                    withAnimation { selectedTab = .month }
                                }
                            }
                        }
                )

                Spacer()
            }
            // Plus 按钮（未激活时显示）
            if !showMask && !showPieMask {
                VStack {
                    Spacer()
                    ZStack {
                        if selectedTab == .day {
                            ZStack {
                                // 加心情按钮居中
                                Button(action: { withAnimation { showMask = true } }) {
                                    ZStack {
                                        Circle().fill(Color.black)
                                            .frame(width: 38, height: 38)
                                            .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
                                        Image(systemName: "plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                    }
                                }
                                // Pie 图标，放在右侧较远处
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        // 这里调用ChatGPT API获取安慰语
                                        fetchPieComfortText()
                                        withAnimation { showPieMask = true }
                                    }) {
                                        Image("Pie")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 38, height: 38)
                                            .shadow(color: Color.black.opacity(0.13), radius: 7, x: 0, y: 3)
                                    }
                                    .padding(.trailing, 40)
                                }
                            }
                            .frame(width: 320, height: 220)
                        } else {
                            // 其他Tab只显示加心情按钮居中
                            Button(action: { withAnimation { showMask = true } }) {
                                ZStack {
                                    Circle().fill(Color.black)
                                        .frame(width: 38, height: 38)
                                        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .frame(width: 220, height: 220)
                    .offset(y: 40)
                    .padding(.bottom, 48)
                }
                .transition(.opacity)
            }

            // Pie 遮罩弹窗
            if showPieMask {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture {
                        withAnimation { showPieMask = false }
                    }
                ZStack {
                    // 分析结果居中
                    if pieComfortText.isEmpty {
                        ProgressView("AI is analyzing your mood...")
                            .font(Font.custom("Poppins-Regular", size: 15))
                            .foregroundColor(Color(hex: "#444444"))
                            .multilineTextAlignment(.center)
                    } else {
                        Text(pieComfortText)
                            .font(Font.custom("Poppins-Regular", size: 15))
                            .foregroundColor(Color(hex: "#444444"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 48)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .zIndex(2)
            }

            // 蒙版和 Exit 按钮（激活时显示）
            if showMask {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture {
                        withAnimation {
                            showMask = false
                            editingEmotion = nil
                        }
                    }

                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 9)
                            .fill(Color.white)
                            .frame(width: 200, height: 36)
                        Text("How was your day?")
                            .font(Font.custom("Poppins-Medium", size: 18))
                            .foregroundColor(Color(hex: "#444444"))
                            .kerning(-0.3)
                            .lineSpacing(6)
                            .frame(width: 200)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 40)
                    ZStack {
                        // 六个情绪表情，环形分布
                        ForEach(EmotionType.allCases, id: \.self) { emotion in
                            Button(action: { editingEmotion = emotion }) {
                                Image(emotion.iconName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 38, height: 38)
                            }
                            .offset(
                                x: [0, 78, 78, 0, -78, -78][EmotionType.allCases.firstIndex(of: emotion)!],
                                y: [-90, -45, 45, 90, 45, -45][EmotionType.allCases.firstIndex(of: emotion)!]
                            )
                        }
                        // Exit 按钮在正中，最后渲染保证在最上层
                        Button(action: { withAnimation { showMask = false } }) {
                            ZStack {
                                Circle().fill(Color.black).frame(width: 38, height: 38)
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(width: 220, height: 220)
                    .offset(y: 40)
                    .padding(.bottom, 48)
                }
                .zIndex(2)
            }
        }
        .fullScreenCover(item: $editingEmotion) { emotion in
            EditEmotionView(
                emotion: emotion,
                date: Date(),
                onDismiss: {
                    editingEmotion = nil
                    showMask = false
                }
            )
        }
    }

    // 替换fetchPieComfortText为ChatGPT API请求
    func fetchPieComfortText() {
        let today = MoodDataManager.shared.records.filter { Calendar.current.isDate($0.dateTime, inSameDayAs: Date()) }.sorted { $0.dateTime > $1.dateTime }.first
        let mood = today?.emotion.rawValue ?? ""
        let content = today?.content ?? ""
        let prompt = """
You are a mindful and supportive companion. The user's mood today is: \(mood). Here is what they wrote: \"\(content)\".

Please provide a short, warm, and encouraging message that:

- Uses mindfulness techniques to help the user acknowledge and accept their feelings.

- Gently encourages the user to take a small positive action or self-care step.

- Helps the user process and soothe any complex or negative emotions.

- Includes a few appropriate emojis to make the message more friendly and comforting.

Please make sure there is a blank line between each paragraph in your reply.

Only use one short and powerful encouraging quote, preferably from a literary work.

Reply in English, be concise, and make the user feel understood and supported.
"""

        pieComfortText = ""
        let apiKey = "" // TODO: 替换为你的OpenAI API Key
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                DispatchQueue.main.async {
                    pieComfortText = "AI分析失败，请稍后重试。"
                }
                return
            }
            DispatchQueue.main.async {
                pieComfortText = content.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }.resume()
    }
}

// 毛玻璃封装
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
} 