import SwiftUI

struct DespesaView: View {

    @StateObject private var viewModel: DespesaViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    private enum Field { case descricao, valor }

    private let purple     = Color(red: 0.42, green: 0.17, blue: 0.88)
    private let deepPurple = Color(red: 0.10, green: 0.03, blue: 0.35)
    private let pink       = Color(red: 0.95, green: 0.24, blue: 0.57)

    init(cartoes: [Cartao] = []) {
        _viewModel = StateObject(wrappedValue: DespesaViewModel(cartoes: cartoes))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                cabecalho
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        descricaoSection
                        dataSection
                        categoriaSection
                        cartaoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }

            registrarButton
        }
        .navigationBarHidden(true)
    }

    // MARK: - Cabeçalho com gradiente + campo de valor

    private var cabecalho: some View {
        ZStack {
            LinearGradient(colors: [purple, deepPurple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top)

            Circle()
                .fill(pink.opacity(0.25))
                .frame(width: 220)
                .offset(x: 130, y: -20)
                .blur(radius: 55)

            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(10)
                            .background(.white.opacity(0.18))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Nova Despesa")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 34, height: 34)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer().frame(height: 22)

                VStack(spacing: 8) {
                    Text("Valor da despesa")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.60))

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("R$")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white.opacity(0.70))

                        ZStack(alignment: .center) {
                            if viewModel.valor.isEmpty {
                                Text("0,00")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.white.opacity(0.30))
                                    .allowsHitTesting(false)
                            }
                            TextField("", text: $viewModel.valor)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .focused($focusedField, equals: .valor)
                                .frame(minWidth: 80, maxWidth: 200)
                        }
                    }
                }
                .padding(.bottom, 28)
            }
        }
    }

    // MARK: - Seção: Descrição

    private var descricaoSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: 10) {
                sectionLabel("Descrição", icon: "text.alignleft")
                TextField("Ex: Jantar no restaurante", text: $viewModel.descricao)
                    .font(.system(size: 16))
                    .focused($focusedField, equals: .descricao)
            }
        }
    }

    // MARK: - Seção: Data

    private var dataSection: some View {
        formCard {
            HStack {
                Label {
                    Text("Data")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(red: 0.12, green: 0.06, blue: 0.28))
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundColor(purple)
                }
                Spacer()
                DatePicker("", selection: $viewModel.data, displayedComponents: .date)
                    .labelsHidden()
                    .tint(purple)
            }
        }
    }

    // MARK: - Seção: Categoria

    private var categoriaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Categoria", icon: "tag.fill")
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(DespesaViewModel.Categoria.allCases) { cat in
                        categoriaChip(cat)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
            }
        }
    }

    private func categoriaChip(_ cat: DespesaViewModel.Categoria) -> some View {
        let selected = viewModel.categoriaSelecionada == cat
        let (bg, fg) = categoriaCor(cat)

        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.categoriaSelecionada = cat
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: cat.icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(cat.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(selected ? .white : fg)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(selected ? bg : bg.opacity(0.12))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(selected ? Color.clear : bg.opacity(0.35), lineWidth: 1))
        }
    }

    private func categoriaCor(_ cat: DespesaViewModel.Categoria) -> (Color, Color) {
        switch cat {
        case .alimentacao: return (Color(red: 1.00, green: 0.57, blue: 0.15), Color(red: 0.82, green: 0.36, blue: 0.00))
        case .transporte:  return (Color(red: 0.22, green: 0.56, blue: 0.96), Color(red: 0.10, green: 0.34, blue: 0.76))
        case .saude:       return (Color(red: 0.95, green: 0.24, blue: 0.57), Color(red: 0.72, green: 0.10, blue: 0.38))
        case .lazer:       return (purple,                                     Color(red: 0.25, green: 0.07, blue: 0.55))
        case .assinaturas: return (Color(red: 0.07, green: 0.75, blue: 0.58), Color(red: 0.02, green: 0.50, blue: 0.40))
        case .compras:     return (Color(red: 0.98, green: 0.76, blue: 0.08), Color(red: 0.65, green: 0.50, blue: 0.00))
        case .outros:      return (Color.secondary,                            Color.secondary)
        }
    }

    // MARK: - Seção: Cartão

    private let miniPaletas: [[Color]] = [
        [Color(red: 0.42, green: 0.17, blue: 0.88), Color(red: 0.10, green: 0.03, blue: 0.40)],
        [Color(red: 1.00, green: 0.45, blue: 0.10), Color(red: 0.90, green: 0.18, blue: 0.50)],
        [Color(red: 0.14, green: 0.17, blue: 0.35), Color(red: 0.06, green: 0.08, blue: 0.20)],
    ]

    private var cartaoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Cartão", icon: "creditcard.fill")
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(viewModel.cartoes.enumerated()), id: \.element.id) { index, cartao in
                        miniCartao(cartao: cartao, index: index)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
            }
        }
    }

    private func miniCartao(cartao: Cartao, index: Int) -> some View {
        let selecionado = viewModel.cartaoSelecionado?.id == cartao.id
        let cores = miniPaletas[index % miniPaletas.count]

        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.cartaoSelecionado = cartao
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(cartao.nome)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    if selecionado {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                Spacer()
                Text("•••• \(cartao.finalCartao)")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.80))
                    .tracking(1.5)
            }
            .padding(14)
            .frame(width: 148, height: 84)
            .background(LinearGradient(colors: cores, startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selecionado ? Color.white : Color.clear, lineWidth: 2.5)
            )
            .shadow(color: cores.first!.opacity(selecionado ? 0.55 : 0.20), radius: selecionado ? 14 : 6, x: 0, y: 5)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.cartaoSelecionado?.id)
    }

    // MARK: - Botão registrar (fixo no rodapé)

    private var registrarButton: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: {
                focusedField = nil
                viewModel.salvar()
                if viewModel.despesaSalva { dismiss() }
            }) {
                Text("Registrar Despesa")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        LinearGradient(
                            colors: viewModel.formularioValido
                                ? [purple, pink]
                                : [Color.gray.opacity(0.40), Color.gray.opacity(0.40)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: viewModel.formularioValido ? purple.opacity(0.40) : .clear,
                        radius: 12, x: 0, y: 6
                    )
            }
            .disabled(!viewModel.formularioValido)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 32)
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: - Helpers

    private func formCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func sectionLabel(_ label: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(purple)
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DespesaView()
}
