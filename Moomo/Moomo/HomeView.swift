import SwiftUI

struct HomeView: View {
    enum Tab: String, CaseIterable { case month = "Month", week = "Week", day = "Day" }
    @State private var selectedTab: Tab = .month

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.93, blue: 0.96).ignoresSafeArea()
            VStack {
                // 顶部Tab栏
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 373, height: 49)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.02), radius: 1, x: 0, y: 1)
                    HStack(spacing: 0) {
                        ForEach(Tab.allCases, id: \ .self) { tab in
                            ZStack {
                                if selectedTab == tab {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 108, height: 33)
                                        .background(Color(red: 0.44, green: 0.24, blue: 0.51))
                                        .cornerRadius(10)
                                }
                                VStack {
                                    Spacer()
                                    Text(tab.rawValue)
                                        .font(Font.custom("Poppins", size: 12).weight(.medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(selectedTab == tab ? .white : Color(red: 0.44, green: 0.24, blue: 0.51))
                                        .frame(width: 79, height: 19, alignment: .center)
                                    Spacer()
                                }
                                .frame(width: 108, height: 33)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedTab = tab }
                            }
                            .frame(width: 124, height: 49, alignment: .center)
                        }
                    }
                    .frame(width: 373, height: 49)
                }
                .padding(.top, 40)

                // Tab内容区
                if selectedTab == .month {
                    // Month内容已移除
                } else if selectedTab == .week {
                    Text("Week 视图开发中")
                        .foregroundColor(.gray)
                        .padding()
                } else if selectedTab == .day {
                    Text("Day 视图开发中")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
        }
    }
} 