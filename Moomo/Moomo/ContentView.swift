//
//  ContentView.swift
//  Moomo
//
//  Created by 邵林峥嵘 on 2025/5/30.
//

import SwiftUI

struct ContentView: View {
    @State private var showLogo = true
    @State private var didAppear = false

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.93, blue: 0.96).ignoresSafeArea()
            HStack(spacing: 0) {
                Spacer().frame(width: 15)
                ZStack {
                    Image("Moomologo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 352, height: 209)
                        .opacity(showLogo ? 1 : 0)
                        .animation(didAppear && !showLogo ? .easeInOut(duration: 1) : nil, value: showLogo)
                }
                .frame(width: 352.28, height: 209)
                Spacer().frame(width: 34.7)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            didAppear = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showLogo = false
            }
        }
    }
} 
