import SwiftUI

/// Tela responsável pelo cadastro de novos gastos.
struct CreateGastoView: View {

    @StateObject private var viewModel =
        CreateGastoViewModel()

    @Environment(\.dismiss) private var dismiss

    let cartao: Cartao

    var body: some View {

        Form {

            Section("Dados do Gasto") {

                TextField(
                    "Descrição",
                    text: $viewModel.descricao
                )

                TextField(
                    "Estabelecimento",
                    text: $viewModel.estabelecimento
                )

                Picker(
                    "Categoria",
                    selection: $viewModel.categoria
                ) {

                    ForEach(
                        CategoriaGasto.allCases,
                        id: \.self
                    ) { categoria in

                        Text(
                            categoria.rawValue
                        )
                        .tag(categoria)
                    }
                }

                TextField(
                    "Valor",
                    text: $viewModel.valor
                )
                .keyboardType(.decimalPad)

                DatePicker(
                    "Data",
                    selection: $viewModel.data,
                    displayedComponents: .date
                )
            }

            Button("Salvar Gasto") {

                viewModel.salvarGasto(
                    cartaoId: cartao.id
                )

                dismiss()
            }
        }
        .navigationTitle("Novo Gasto")
    }
}

#Preview {

    NavigationStack {

        CreateGastoView(
            cartao: Cartao(
                id: UUID(),
                nome: "Nubank",
                limiteTotal: 5000,
                finalCartao: "1234",
                cvv: "123",
                status: .ativo,
                tipo: .fisico,
                gastos: []
            )
        )
    }
}
