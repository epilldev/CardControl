import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?

    private enum Field { case email, senha }

    private let purple = Color(red: 0.42, green: 0.17, blue: 0.88)
    private let deepPurple = Color(red: 0.10, green: 0.03, blue: 0.35)
    private let pink = Color(red: 0.95, green: 0.24, blue: 0.57)
    private let orange = Color(red: 1.0, green: 0.57, blue: 0.15)

    var body: some View {
        ZStack {
            LinearGradient(colors: [purple, deepPurple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Circle()
                .fill(Color(red: 0.68, green: 0.33, blue: 1.0).opacity(0.35))
                .frame(width: 320)
                .offset(x: 140, y: -220)
                .blur(radius: 70)

            Circle()
                .fill(pink.opacity(0.3))
                .frame(width: 260)
                .offset(x: -110, y: 320)
                .blur(radius: 70)

            VStack(spacing: 0) {
                Spacer()
                logoArea
                Spacer().frame(height: 44)
                formCard
                Spacer()
            }
        }
        .navigationBarHidden(true)

        NavigationLink(destination: HomeView(), isActive: $viewModel.usuarioAutenticado) {
            EmptyView()
        }
    }

    private var logoArea: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [pink, orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 84, height: 84)
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 34))
                    .foregroundColor(.white)
            }
            .shadow(color: pink.opacity(0.55), radius: 24, x: 0, y: 10)

            Text("CardControl")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)

            Text("Gerencie seus cartões com facilidade")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.65))
        }
    }

    private var formCard: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                inputField(title: "E-mail", text: $viewModel.email, isSecure: false, field: .email, icon: "envelope.fill")
                inputField(title: "Senha", text: $viewModel.senha, isSecure: true, field: .senha, icon: "lock.fill")
            }

            loginButton

        }
        .padding(28)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.28), radius: 36, x: 0, y: 18)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func inputField(
        title: String,
        text: Binding<String>,
        isSecure: Bool,
        field: Field,
        icon: String
    ) -> some View {
        let focused = focusedField == field
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(focused ? purple : .secondary)
                .frame(width: 20)
                .animation(.easeInOut(duration: 0.2), value: focusedField)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(focused ? purple : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: focusedField)

                Group {
                    if isSecure {
                        SecureField("", text: text)
                    } else {
                        TextField("", text: text)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
                .focused($focusedField, equals: field)
                .font(.system(size: 16))
            }
        }
        .padding(16)
        .background(focused ? purple.opacity(0.06) : Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(focused ? purple : Color.clear, lineWidth: 1.5)
        )
        .animation(.easeInOut(duration: 0.2), value: focusedField)
    }

    private var loginButton: some View {
        Button(action: {
            focusedField = nil
            viewModel.realizarLogin()
        }) {
            Text("Entrar")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .background(
                    LinearGradient(colors: [purple, pink], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: purple.opacity(0.45), radius: 14, x: 0, y: 7)
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
