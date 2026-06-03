import SwiftUI

/// Tela responsável pelo cadastro de novos cartões.
struct CreateCardView: View {

    @StateObject private var viewModel =
        CreateCardViewModel()

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        Form {

            Section("Dados do Cartão") {

                TextField(
                    "Nome do cartão",
                    text: $viewModel.nome
                )

                TextField(
                    "Limite Total",
                    text: $viewModel.limiteTotal
                )
                .keyboardType(.decimalPad)

                TextField(
                    "Final do Cartão",
                    text: $viewModel.finalCartao
                )

                TextField(
                    "CVV",
                    text: $viewModel.cvv
                )
                .keyboardType(.numberPad)
            }

            Button("Salvar Cartão") {

                viewModel.salvarCartao()

                dismiss()
            }
        }
        .navigationTitle("Novo Cartão")
    }
}

#Preview {
    NavigationStack {
        CreateCardView()
    }
}
