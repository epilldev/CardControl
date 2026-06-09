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
            
            VStack(spacing: 12) {
                
                Image(systemName: "sparkles")
                    .font(.system(size: 26))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [purple, pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Bem-vindo ao CardControl")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(deepPurple)
                
                Text(
                    "Acesse sua conta para gerenciar cartões, limites e despesas em um único lugar."
                )
                .font(.subheadline)
                .foregroundColor(
                    deepPurple.opacity(0.70)
                )
                .multilineTextAlignment(.center)
            }
            
            googleButton
            
            HStack(spacing: 6) {
                
                Image(systemName: "lock.shield.fill")
                    .font(.caption)
                
                Text(
                    "Login protegido por Google e Firebase"
                )
                .font(.caption)
            }
            .foregroundColor(.secondary)
        }
        .padding(28)
        .background(
            .ultraThinMaterial
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 28
            )
            .stroke(
                Color.white.opacity(0.25),
                lineWidth: 1
            )
        )
        .shadow(
            color: .black.opacity(0.15),
            radius: 20,
            x: 0,
            y: 10
        )
        .padding(.horizontal, 24)
    }
    // MARK: - Google Button
    
    private var googleButton: some View {
        
        Button {
            
            viewModel.realizarLoginGoogle()
            
        } label: {
            
            HStack(spacing: 12) {
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Text("Continuar com Google")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(
                    systemName: "arrow.right.circle.fill"
                )
                .font(.system(size: 20))
                .foregroundColor(
                    .white.opacity(0.85)
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [purple, pink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
            .shadow(
                color: purple.opacity(0.40),
                radius: 12,
                x: 0,
                y: 6
            )
        }
    }
}

#Preview {
    
    NavigationStack {
        
        LoginView()
    }
}
