import SwiftUI

/// Tela principal exibida após autenticação do usuário.
struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                Text("Meus Cartões")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Gerencie seus cartões e acompanhe seus limites.")
                    .foregroundColor(.secondary)

                ForEach(viewModel.cartoes) { cartao in
                    CardView(cartao: cartao)
                }
            }
            .padding()
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
