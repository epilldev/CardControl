import SwiftUI

/// Tela responsável pela autenticação inicial do usuário.
struct LoginView: View {

    @StateObject private var viewModel = LoginViewModel()

    var body: some View {

        VStack(spacing: 24) {

            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 72))
                .foregroundColor(.blue)

            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Acesse sua conta para gerenciar seus cartões.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            TextField("E-mail", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)

            SecureField("Senha", text: $viewModel.senha)
                .textFieldStyle(.roundedBorder)

            Button("Entrar") {
                viewModel.realizarLogin()
            }
            .buttonStyle(.borderedProminent)

            NavigationLink(
                destination: HomeView(),
                isActive: $viewModel.usuarioAutenticado
            ) {
                EmptyView()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Login")
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
