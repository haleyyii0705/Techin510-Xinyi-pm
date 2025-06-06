import SwiftUI

struct MonthView: View {
    @ObservedObject private var moodManager = MoodDataManager.shared
    @Binding var currentDate: Date
    @State private var showMask = false
    private let calendar = Calendar.current
    var onDateSelected: (Date) -> Void = { _ in }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 0) {
                    // 顶部时间信息居中
                    VStack(spacing: 0) {
                        // 只显示年份
                        Text(monthYear)
                            .font(Font.custom("Poppins-Regular", size: 10))
                            .foregroundColor(Color(hex: "#939393"))
                            .frame(maxWidth: .infinity, alignment: .center)
                        // 只显示月份（不带年份）
                        Text(monthOnlyTitle)
                            .font(Font.custom("Poppins-Regular", size: 16).weight(.semibold))
                            .kerning(-0.4)
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.top, 24)

                    Spacer().frame(height: 24)

                    // Sun-Sat 星期缩写行（只保留这里）
                    let weekAbbr = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    HStack(spacing: 10) {
                        ForEach(weekAbbr, id: \.self) { abbr in
                            Text(abbr)
                                .font(Font.custom("Poppins-Regular", size: 10).weight(.medium))
                                .foregroundColor(Color(red: 0.58, green: 0.58, blue: 0.58))
                                .frame(width: 40, height: 13, alignment: .center)
                        }
                    }

                    // 日历主体
                    ZStack {
                        calendarGrid
                    }
                    .frame(width: 358)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height < -50 {
                                    withAnimation { currentDate = nextMonth(from: currentDate) }
                                } else if value.translation.height > 50 {
                                    withAnimation { currentDate = previousMonth(from: currentDate) }
                                }
                            }
                    )
                    Spacer()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    // 计算当前年月标题
    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy  MMMM"
        return formatter.string(from: currentDate)
    }

    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: currentDate)
    }

    // 新增只显示月份的属性
    var monthOnlyTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: currentDate)
    }

    // 日历网格（只渲染日期数字和圆圈，不再包含 Sun-Sat 行）
    var calendarGrid: some View {
        let days = daysInMonth()
        let firstWeekday = firstWeekdayOfMonth()
        let rows = Int(ceil(Double(days + firstWeekday - 1) / 7.0))
        return VStack(spacing: 40) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<7, id: \.self) { col in
                        let day = row * 7 + col - (firstWeekday - 1) + 1
                        VStack(spacing: 4) {
                            if day >= 1 && day <= days {
                                Button(action: {
                                    let date = dateForDay(day)
                                    onDateSelected(date)
                                }) {
                                    Text("\(day)")
                                        .font(Font.custom("Poppins-Regular", size: 10))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.58, green: 0.58, blue: 0.58))
                                        .frame(width: 40, height: 13, alignment: .center)
                                }
                                Button(action: {
                                    let date = dateForDay(day)
                                    onDateSelected(date)
                                }) {
                                    if let record = MoodDataManager.shared.latestRecord(for: dateForDay(day)) {
                                        Image(record.emotion.iconName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                    } else {
                                        Image("Ellipse 199")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1.5)
                                            )
                                    }
                                }
                            } else {
                                Spacer().frame(width: 40, height: 57)
                            }
                        }
                        .frame(width: 40, alignment: .center)
                    }
                }
            }
        }
    }

    // 获取当月天数
    func daysInMonth() -> Int {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        return range.count
    }

    // 获取当月1号是周几（1=周日，2=周一...7=周六）
    func firstWeekdayOfMonth() -> Int {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let firstDay = calendar.date(from: components)!
        return calendar.component(.weekday, from: firstDay)
    }

    // 上个月
    func previousMonth(from date: Date) -> Date {
        calendar.date(byAdding: .month, value: -1, to: date) ?? date
    }

    // 下个月
    func nextMonth(from date: Date) -> Date {
        calendar.date(byAdding: .month, value: 1, to: date) ?? date
    }

    // 获取某天的 Date
    func dateForDay(_ day: Int) -> Date {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: DateComponents(year: components.year, month: components.month, day: day)) ?? Date()
    }
}

struct TestView: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .focused($isFocused)
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(currentDate: .constant(Date()))
    }
} 