import SwiftUI

/// Tela responsável pela autenticação inicial do usuário.
struct LoginView: View {

    var body: some View {

        VStack(spacing: 24) {

            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 72))
                .foregroundColor(.blue)

            Text("Tela de Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Aqui o usuário poderá acessar sua conta e gerenciar seus cartões.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            NavigationLink("Entrar no App") {
                HomeView()
            }
            .buttonStyle(.borderedProminent)

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
