//
//  MoomoApp.swift
//  Moomo
//
//  Created by 邵林峥嵘 on 2025/5/30.
//

import SwiftUI

@main
struct MoomoApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    ContentView()
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                } else {
                    HomeView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
}
