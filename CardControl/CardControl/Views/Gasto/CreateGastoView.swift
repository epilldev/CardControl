import SwiftUI
import UIKit

/// Tela responsável pelo cadastro de novos gastos.
struct CreateGastoView: View {

    @StateObject private var viewModel =
        CreateGastoViewModel()

    @Environment(\.dismiss)
    private var dismiss

    @State private var mostrarErro = false

    let cartao: Cartao

    var body: some View {

        ZStack {

            Color(
                red: 0.96,
                green: 0.94,
                blue: 1.00
            )
            .ignoresSafeArea()

            Form {

                cabecalho

                cartaoSelecionado

                previewGasto

                dadosGasto

                botaoSalvar
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Novo Gasto")
        .navigationBarTitleDisplayMode(.inline)

        .alert(
            "Não foi possível cadastrar o gasto",
            isPresented: $mostrarErro
        ) {

            Button("OK") { }

        } message: {

            Text(viewModel.mensagemErro)
        }
    }

    // MARK: - Cabeçalho

    private var cabecalho: some View {

        Section {

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text("Novo Gasto")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(
                    "Registre uma despesa vinculada ao cartão selecionado."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Cartão

    private var cartaoSelecionado: some View {

        Section("Cartão Selecionado") {

            VStack(
                alignment: .leading,
                spacing: 8
            ) {

                Text(cartao.nome)
                    .font(.headline)

                Text("•••• \(cartao.finalCartao)")
                    .foregroundColor(.secondary)

                Text(
                    "Disponível: \(cartao.limiteDisponivel.moeda)"
                )
                .font(.caption)
                .foregroundColor(.green)
            }
        }
    }

    // MARK: - Preview

    private var previewGasto: some View {

        Section("Pré-visualização") {

            VStack(
                alignment: .leading,
                spacing: 12
            ) {

                Text(
                    viewModel.descricao.isEmpty
                    ? "Descrição do gasto"
                    : viewModel.descricao
                )
                .font(.headline)

                Text(
                    viewModel.estabelecimento.isEmpty
                    ? "Estabelecimento"
                    : viewModel.estabelecimento
                )
                .foregroundColor(.secondary)

                Text(
                    valorFormatado ?? "R$ 0,00"
                )
                .font(.title3)
                .fontWeight(.bold)

                Text(
                    viewModel.categoria.rawValue
                )
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Dados

    private var dadosGasto: some View {

        Section("Dados do Gasto") {

            HStack {

                Image(systemName: "text.alignleft")
                    .foregroundColor(.purple)

                TextField(
                    "Descrição",
                    text: $viewModel.descricao
                )
            }

            HStack {

                Image(systemName: "building.2.fill")
                    .foregroundColor(.blue)

                TextField(
                    "Estabelecimento",
                    text: $viewModel.estabelecimento
                )
            }

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

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                HStack {

                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)

                    TextField(
                        "Ex: 39,90",
                        text: $viewModel.valor
                    )
                }
                .keyboardType(.decimalPad)
                .onChange(
                    of: viewModel.valor
                ) { _, novoValor in

                    let filtrado =
                        novoValor.filter {

                            $0.isNumber ||
                            $0 == "," ||
                            $0 == "."
                        }

                    viewModel.valor = filtrado
                }

                if let valor = valorFormatado {

                    Text(
                        "Valor informado: \(valor)"
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }

            DatePicker(
                "Data",
                selection: $viewModel.data,
                displayedComponents: .date
            )
        }
    }

    // MARK: - Salvar

    private var botaoSalvar: some View {

        Section {

            Button {

                if viewModel.validarDados() {

                    viewModel.salvarGasto(
                        cartaoId: cartao.id
                    )

                    UINotificationFeedbackGenerator()
                        .notificationOccurred(.success)

                    dismiss()

                } else {

                    UINotificationFeedbackGenerator()
                        .notificationOccurred(.error)

                    mostrarErro = true
                }

            } label: {

                Text("Salvar Gasto")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(
                .borderedProminent
            )
            .tint(
                Color(
                    red: 0.42,
                    green: 0.17,
                    blue: 0.88
                )
            )
            .disabled(!podeSalvar)
            .opacity(
                podeSalvar ? 1 : 0.6
            )
        }
    }

    // MARK: - Helpers

    private var valorFormatado: String? {

        let texto =
            viewModel.valor
                .replacingOccurrences(
                    of: ",",
                    with: "."
                )

        guard let valor =
                Double(texto)
        else {
            return nil
        }

        let formatter =
            NumberFormatter()

        formatter.numberStyle =
            .currency

        formatter.locale =
            Locale(
                identifier: "pt_BR"
            )

        return formatter.string(
            from: NSNumber(
                value: valor
            )
        )
    }

    private var podeSalvar: Bool {

        !viewModel.descricao
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
        &&
        !viewModel.estabelecimento
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
        &&
        !viewModel.valor.isEmpty
    }
}

// MARK: - Formatter

private extension Double {

    var moeda: String {

        let formatter =
            NumberFormatter()

        formatter.numberStyle =
            .currency

        formatter.locale =
            Locale(
                identifier: "pt_BR"
            )

        return formatter.string(
            from: NSNumber(
                value: self
            )
        ) ?? "R$ 0,00"
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
