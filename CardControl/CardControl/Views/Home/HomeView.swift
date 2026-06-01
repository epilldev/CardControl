import SwiftUI

/// Tela principal exibida após autenticação do usuário.
struct HomeView: View {

    var body: some View {

        VStack(spacing: 24) {

            Image(systemName: "creditcard.fill")
                .font(.system(size: 72))
                .foregroundColor(.blue)

            Text("Home do Aplicativo")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Aqui serão exibidos os cartões cadastrados e ações rápidas do sistema.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
