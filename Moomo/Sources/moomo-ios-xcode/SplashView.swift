import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 208/255, green: 188/255, blue: 255/255)
                .ignoresSafeArea()
            Image("moomo_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 320, height: 194)
        }
    }
} 