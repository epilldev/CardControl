import SwiftUI

struct CardDetailsView: View {

    @StateObject private var viewModel =
        CardDetailsViewModel()

    @Environment(\.dismiss) private var dismiss

    @State private var novoLimite: Double = 0
    @State private var cartaoAtivo = false
    @State private var mostrarConfirmacaoExclusao = false

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

                Section {

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        Text(cartao.nome)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(
                            "•••• •••• •••• \(cartao.finalCartao)"
                        )
                        .foregroundColor(
                            .white.opacity(0.9)
                        )

                        Text(
                            "Limite: R$ \(cartao.limiteTotal, specifier: "%.2f")"
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

                Section("Limite") {

                    Text(
                        "Limite Total: R$ \(cartao.limiteTotal, specifier: "%.2f")"
                    )

                    Text(
                        "Disponível: R$ \(cartao.limiteDisponivel, specifier: "%.2f")"
                    )
                }

                Section("Status") {

                    Toggle(
                        "Cartão Ativo",
                        isOn: $cartaoAtivo
                    )
                    .tint(
                        Color(
                            red: 0.42,
                            green: 0.17,
                            blue: 0.88
                        )
                    )
                    .onChange(of: cartaoAtivo) { _, ativo in

                        viewModel.atualizarStatus(
                            cartao: cartao,
                            ativo: ativo
                        )
                    }
                }

                Section("Alterar Limite") {

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        Text(
                            "Novo Limite: R$ \(novoLimite, specifier: "%.0f")"
                        )
                        .font(.headline)

                        Slider(
                            value: $novoLimite,
                            in: 1000...20000,
                            step: 100,
                            onEditingChanged: { editando in

                                if !editando {

                                    viewModel.alterarLimite(
                                        cartao: cartao,
                                        novoLimite: novoLimite
                                    )
                                }
                            }
                        )
                        .tint(
                            Color(
                                red: 0.42,
                                green: 0.17,
                                blue: 0.88
                            )
                        )

                        HStack {

                            Text("R$ 1.000")

                            Spacer()

                            Text("R$ 20.000")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }

                Section {

                    Button(
                        role: .destructive
                    ) {

                        mostrarConfirmacaoExclusao = true

                    } label: {

                        Label(
                            "Excluir Cartão",
                            systemImage: "trash"
                        )
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(cartao.nome)
        .alert(
            "Excluir Cartão",
            isPresented: $mostrarConfirmacaoExclusao
        ) {

            Button(
                "Cancelar",
                role: .cancel
            ) { }

            Button(
                "Excluir",
                role: .destructive
            ) {

                viewModel.removerCartao(
                    id: cartao.id
                )

                dismiss()
            }

        } message: {

            Text(
                "Deseja realmente excluir este cartão?"
            )
        }
        .onAppear {

            cartaoAtivo =
                cartao.status == .ativo

            novoLimite =
                cartao.limiteTotal
        }
    }
}
