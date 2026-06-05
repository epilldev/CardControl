import SwiftUI

/// Tela responsável pelo cadastro de novos cartões.
struct CreateCardView: View {

    @StateObject private var viewModel =
        CreateCardViewModel()

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {

            Color(
                red: 0.96,
                green: 0.94,
                blue: 1.00
            )
            .ignoresSafeArea()

            Form {

                Section {

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        Text("Novo Cartão")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(
                            "Cadastre um novo cartão para controlar seus gastos."
                        )
                        .foregroundColor(
                            .white.opacity(0.9)
                        )
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                Color(
                                    red: 0.42,
                                    green: 0.17,
                                    blue: 0.88
                                ),
                                Color(
                                    red: 0.10,
                                    green: 0.03,
                                    blue: 0.35
                                )
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                }

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

                    Toggle(
                        "Cartão Virtual",
                        isOn: $viewModel.cartaoVirtual
                    )
                    .tint(
                        Color(
                            red: 0.42,
                            green: 0.17,
                            blue: 0.88
                        )
                    )
                }

                Section {

                    Button {

                        viewModel.salvarCartao()

                        dismiss()

                    } label: {

                        Text("Salvar Cartão")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(
                        Color(
                            red: 0.42,
                            green: 0.17,
                            blue: 0.88
                        )
                    )
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Novo Cartão")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        CreateCardView()
    }
}
