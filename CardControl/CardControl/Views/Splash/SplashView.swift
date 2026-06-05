import SwiftUI

struct SplashView: View {

    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.55
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGFloat = 18
    @State private var loaderOpacity: Double = 0

    private let purple     = Color(red: 0.42, green: 0.17, blue: 0.88)
    private let deepPurple = Color(red: 0.10, green: 0.03, blue: 0.35)
    private let pink       = Color(red: 0.95, green: 0.24, blue: 0.57)
    private let orange     = Color(red: 1.00, green: 0.57, blue: 0.15)

    var body: some View {
        if isActive {
            NavigationStack {
                LoginView()
            }
        } else {
            splash
                .onAppear { animarEntrada() }
        }
    }

    // MARK: - Splash

    private var splash: some View {
        ZStack {
            LinearGradient(colors: [purple, deepPurple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Circle()
                .fill(pink.opacity(0.30))
                .frame(width: 340)
                .offset(x: 150, y: -260)
                .blur(radius: 80)

            Circle()
                .fill(orange.opacity(0.20))
                .frame(width: 280)
                .offset(x: -120, y: 340)
                .blur(radius: 80)

            VStack(spacing: 0) {
                Spacer()

                logoIcon
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                Spacer().frame(height: 28)

                VStack(spacing: 6) {
                    Text("CardControl")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)

                    Text("Seus cartões sob controle")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.60))
                        .offset(y: subtitleOffset)
                }
                .opacity(titleOpacity)

                Spacer()

                ProgressView()
                    .tint(.white.opacity(0.45))
                    .scaleEffect(1.2)
                    .padding(.bottom, 64)
                    .opacity(loaderOpacity)
            }
        }
    }

    private var logoIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(colors: [pink, orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 104, height: 104)

            Image(systemName: "creditcard.fill")
                .font(.system(size: 42))
                .foregroundColor(.white)
        }
        .shadow(color: pink.opacity(0.55), radius: 32, x: 0, y: 14)
    }

    // MARK: - Animações

    private func animarEntrada() {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.58)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.55).delay(0.35)) {
            titleOpacity = 1.0
            subtitleOffset = 0
        }
        withAnimation(.easeIn(duration: 0.4).delay(0.7)) {
            loaderOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            withAnimation(.easeInOut(duration: 0.35)) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashView()
}
