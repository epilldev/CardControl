import SwiftUI

struct RegistroFaturaView: View {

    @StateObject private var viewModel: FaturaViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    private enum Field { case valor, observacao }

    private let teal     = Color(red: 0.07, green: 0.75, blue: 0.58)
    private let darkTeal = Color(red: 0.02, green: 0.40, blue: 0.32)
    private let pink     = Color(red: 0.95, green: 0.24, blue: 0.57)
    private let orange   = Color(red: 1.00, green: 0.57, blue: 0.15)
    private let darkText = Color(red: 0.12, green: 0.06, blue: 0.28)

    private let miniPaletas: [[Color]] = [
        [Color(red: 0.42, green: 0.17, blue: 0.88), Color(red: 0.10, green: 0.03, blue: 0.40)],
        [Color(red: 1.00, green: 0.45, blue: 0.10), Color(red: 0.90, green: 0.18, blue: 0.50)],
        [Color(red: 0.14, green: 0.17, blue: 0.35), Color(red: 0.06, green: 0.08, blue: 0.20)],
    ]

    init(cartoes: [Cartao] = []) {
        _viewModel = StateObject(wrappedValue: FaturaViewModel(cartoes: cartoes))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                cabecalho
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        cartaoSection
                        vencimentoSection
                        mesReferenciaSection
                        statusSection
                        observacaoSection
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

    // MARK: - Cabeçalho

    private var cabecalho: some View {
        ZStack {
            LinearGradient(colors: [teal, darkTeal], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top)

            Circle()
                .fill(pink.opacity(0.20))
                .frame(width: 200)
                .offset(x: 130, y: -20)
                .blur(radius: 55)

            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 160)
                .offset(x: -80, y: 55)
                .blur(radius: 40)

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
                    Text("Registrar Fatura")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 34, height: 34)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer().frame(height: 22)

                VStack(spacing: 8) {
                    Text("Valor da fatura")
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

    // MARK: - Seção: Cartão

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

    // MARK: - Seção: Vencimento

    private var vencimentoSection: some View {
        formCard {
            HStack {
                Label {
                    Text("Vencimento")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(darkText)
                } icon: {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .foregroundColor(teal)
                }
                Spacer()
                DatePicker("", selection: $viewModel.vencimento, displayedComponents: .date)
                    .labelsHidden()
                    .tint(teal)
            }
        }
    }

    // MARK: - Seção: Mês de Referência

    private var mesReferenciaSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionLabel("Mês de Referência", icon: "calendar.circle.fill")

                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) { viewModel.retrocederMes() }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(teal)
                            .frame(width: 36, height: 36)
                            .background(teal.opacity(0.12))
                            .clipShape(Circle())
                    }

                    Spacer()

                    VStack(spacing: 2) {
                        Text(viewModel.mesReferenciaNome)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(darkText)
                            .animation(.easeInOut(duration: 0.15), value: viewModel.mesReferenciaNome)
                        Text(String(viewModel.anoReferencia))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .animation(.easeInOut(duration: 0.15), value: viewModel.anoReferencia)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) { viewModel.avancarMes() }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(teal)
                            .frame(width: 36, height: 36)
                            .background(teal.opacity(0.12))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }

    // MARK: - Seção: Status

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Status", icon: "circle.fill")
                .padding(.horizontal, 4)

            HStack(spacing: 10) {
                statusChip(.pendente, label: "Pendente", cor: orange)
                statusChip(.paga,     label: "Paga",     cor: teal)
                statusChip(.atrasada, label: "Atrasada", cor: pink)
            }
        }
    }

    private func statusChip(_ status: StatusFatura, label: String, cor: Color) -> some View {
        let selected = viewModel.status == status
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) { viewModel.status = status }
        }) {
            HStack(spacing: 6) {
                Image(systemName: status.icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(selected ? .white : cor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(selected ? cor : cor.opacity(0.12))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(selected ? Color.clear : cor.opacity(0.35), lineWidth: 1))
            .shadow(color: selected ? cor.opacity(0.35) : .clear, radius: 6, x: 0, y: 3)
        }
    }

    // MARK: - Seção: Observação

    private var observacaoSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: 10) {
                sectionLabel("Observação (opcional)", icon: "note.text")
                TextField("Ex: Fatura com cashback", text: $viewModel.observacao)
                    .font(.system(size: 16))
                    .focused($focusedField, equals: .observacao)
            }
        }
    }

    // MARK: - Botão Registrar

    private var registrarButton: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: {
                focusedField = nil
                viewModel.salvar()
                if viewModel.faturaSalva { dismiss() }
            }) {
                Text("Registrar Fatura")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        LinearGradient(
                            colors: viewModel.formularioValido
                                ? [teal, darkTeal]
                                : [Color.gray.opacity(0.40), Color.gray.opacity(0.40)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(
                        color: viewModel.formularioValido ? teal.opacity(0.40) : .clear,
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
                .foregroundColor(teal)
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RegistroFaturaView()
}
