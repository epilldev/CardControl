import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel =
        LoginViewModel()

    private let purple =
        Color(red: 0.42, green: 0.17, blue: 0.88)

    private let deepPurple =
        Color(red: 0.10, green: 0.03, blue: 0.35)

    private let pink =
        Color(red: 0.95, green: 0.24, blue: 0.57)

    private let orange =
        Color(red: 1.0, green: 0.57, blue: 0.15)

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [purple, deepPurple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(
                    Color(
                        red: 0.68,
                        green: 0.33,
                        blue: 1.0
                    )
                    .opacity(0.35)
                )
                .frame(width: 320)
                .offset(x: 140, y: -220)
                .blur(radius: 70)

            Circle()
                .fill(
                    pink.opacity(0.3)
                )
                .frame(width: 260)
                .offset(x: -110, y: 320)
                .blur(radius: 70)

            VStack(spacing: 0) {

                Spacer()

                logoArea

                Spacer()
                    .frame(height: 44)

                formCard

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: HomeView(),
                isActive: $viewModel.usuarioAutenticado
            ) {
                EmptyView()
            }
            .hidden()
        )
    }

    // MARK: - Logo

    private var logoArea: some View {

        VStack(spacing: 16) {

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [pink, orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 84, height: 84)

                Image(systemName: "creditcard.fill")
                    .font(.system(size: 34))
                    .foregroundColor(.white)
            }
            .shadow(
                color: pink.opacity(0.55),
                radius: 24,
                x: 0,
                y: 10
            )

            Text("CardControl")
                .font(
                    .system(
                        size: 30,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)

            Text(
                "Gerencie seus cartões com facilidade"
            )
            .font(.subheadline)
            .foregroundColor(
                .white.opacity(0.65)
            )
        }
    }

    // MARK: - Card

    private var formCard: some View {

        VStack(spacing: 24) {

            VStack(spacing: 8) {

                Text("Bem-vindo")
                    .font(.title3)
                    .fontWeight(.bold)

                Text(
                    "Entre com sua conta Google para sincronizar seus cartões e despesas."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            }

            googleButton

            Text(
                "Seu login é protegido pelo Google e Firebase."
            )
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(28)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28
            )
        )
        .shadow(
            color: .black.opacity(0.28),
            radius: 36,
            x: 0,
            y: 18
        )
        .padding(.horizontal, 24)
    }

    // MARK: - Google Button

    private var googleButton: some View {

        Button {

            // Implementaremos no próximo passo

        } label: {

            HStack(spacing: 12) {

                Image(systemName: "globe")

                Text("Entrar com Google")
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .overlay(
                RoundedRectangle(
                    cornerRadius: 14
                )
                .stroke(
                    Color.gray.opacity(0.25),
                    lineWidth: 1
                )
            )
        }
    }
}

#Preview {

    NavigationStack {

        LoginView()
    }
}
