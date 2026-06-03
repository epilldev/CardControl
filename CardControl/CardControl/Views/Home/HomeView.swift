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

                NavigationLink("Novo Cartão") {
                    CreateCardView()
                }
                .buttonStyle(.borderedProminent)

                if viewModel.cartoes.isEmpty {

                    Text("Nenhum cartão cadastrado.")
                        .foregroundColor(.secondary)

                } else {

                    ForEach(viewModel.cartoes) { cartao in

                        VStack(alignment: .leading, spacing: 8) {

                            CardView(cartao: cartao)

                            Button(role: .destructive) {

                                viewModel.removerCartao(
                                    id: cartao.id
                                )

                            } label: {
                                Text("Excluir Cartão")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Home")
        .onAppear {
            viewModel.carregarCartoes()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
