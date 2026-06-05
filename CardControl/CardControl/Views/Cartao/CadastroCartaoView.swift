import SwiftUI

struct CadastroCartaoView: View {

    @StateObject private var viewModel = CadastroCartaoViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    private enum Field { case nome, finalCartao, limite }

    private let purple     = Color(red: 0.42, green: 0.17, blue: 0.88)
    private let deepPurple = Color(red: 0.10, green: 0.03, blue: 0.35)
    private let pink       = Color(red: 0.95, green: 0.24, blue: 0.57)
    private let teal       = Color(red: 0.07, green: 0.75, blue: 0.58)
    private let orange     = Color(red: 1.00, green: 0.57, blue: 0.15)
    private let darkText   = Color(red: 0.12, green: 0.06, blue: 0.28)

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                cabecalho
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        informacoesSection
                        limiteSection
                        tipoSection
                        statusSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }

            salvarButton
        }
        .navigationBarHidden(true)
    }

    // MARK: - Cabeçalho com preview ao vivo do cartão

    private var cabecalho: some View {
        ZStack {
            LinearGradient(colors: [purple, deepPurple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top)

            Circle()
                .fill(teal.opacity(0.25))
                .frame(width: 240)
                .offset(x: 130, y: -30)
                .blur(radius: 60)

            Circle()
                .fill(orange.opacity(0.18))
                .frame(width: 180)
                .offset(x: -80, y: 60)
                .blur(radius: 50)

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
                    Text("Novo Cartão")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 34, height: 34)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer().frame(height: 20)

                previewCartao
                    .padding(.horizontal, 24)

                Spacer().frame(height: 28)
            }
        }
    }

    private var previewCartao: some View {
        ZStack {
            LinearGradient(colors: [purple, deepPurple], startPoint: .topLeading, endPoint: .bottomTrailing)

            Circle().fill(.white.opacity(0.07)).frame(width: 200).offset(x: 110, y: -30)
            Circle().fill(.white.opacity(0.05)).frame(width: 155).offset(x: 140, y: 62)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(viewModel.nome.isEmpty ? "Nome do Cartão" : viewModel.nome)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(viewModel.nome.isEmpty ? .white.opacity(0.35) : .white)
                        .lineLimit(1)
                        .animation(.easeInOut(duration: 0.15), value: viewModel.nome)
                    Spacer()
                    previewTipoBadge
                }

                Spacer()

                HStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.yellow.opacity(0.85))
                    Spacer()
                    previewStatusBadge
                }

                Spacer().frame(height: 12)

                Text("•••• •••• •••• \(viewModel.finalCartao.isEmpty ? "____" : viewModel.finalCartao)")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(viewModel.finalCartao.isEmpty ? .white.opacity(0.35) : .white.opacity(0.9))
                    .tracking(2)
                    .animation(.easeInOut(duration: 0.1), value: viewModel.finalCartao)
            }
            .padding(22)
        }
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.28), radius: 22, x: 0, y: 10)
    }

    private var previewTipoBadge: some View {
        Text(viewModel.tipo == .virtual ? "Virtual" : "Físico")
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.white.opacity(0.20))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .animation(.easeInOut(duration: 0.15), value: viewModel.tipo)
    }

    private var previewStatusBadge: some View {
        let (label, cor) = statusPreviewInfo
        return Text(label)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(cor.opacity(0.25))
            .foregroundColor(cor)
            .clipShape(Capsule())
            .animation(.easeInOut(duration: 0.15), value: viewModel.status)
    }

    private var statusPreviewInfo: (String, Color) {
        switch viewModel.status {
        case .ativo:     return ("Ativo",     Color(red: 0.25, green: 1.00, blue: 0.65))
        case .bloqueado: return ("Bloqueado", Color(red: 1.00, green: 0.78, blue: 0.15))
        case .cancelado: return ("Cancelado", Color(red: 1.00, green: 0.38, blue: 0.38))
        }
    }

    // MARK: - Seção: Informações

    private var informacoesSection: some View {
        formCard {
            VStack(spacing: 0) {
                sectionLabel("Informações do Cartão", icon: "creditcard")
                    .padding(.bottom, 14)

                inputRow(
                    icon: "building.columns.fill",
                    placeholder: "Nome do banco ou cartão",
                    text: $viewModel.nome,
                    field: .nome
                )

                Divider().padding(.leading, 32).padding(.vertical, 12)

                inputRow(
                    icon: "number",
                    placeholder: "Últimos 4 dígitos",
                    text: $viewModel.finalCartao,
                    field: .finalCartao,
                    keyboard: .numberPad
                )
                .onChange(of: viewModel.finalCartao) { newValue in
                    let digits = newValue.filter { $0.isNumber }
                    let limited = String(digits.prefix(4))
                    if limited != newValue { viewModel.finalCartao = limited }
                }
            }
        }
    }

    // MARK: - Seção: Limite

    private var limiteSection: some View {
        formCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionLabel("Limite do Cartão", icon: "chart.bar.fill")

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("R$")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.secondary)

                    ZStack(alignment: .leading) {
                        if viewModel.limite.isEmpty {
                            Text("0,00")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(darkText.opacity(0.25))
                                .allowsHitTesting(false)
                        }
                        TextField("", text: $viewModel.limite)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(darkText)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .limite)
                    }
                }
            }
        }
    }

    // MARK: - Seção: Tipo

    private var tipoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Tipo de Cartão", icon: "creditcard.and.123")
                .padding(.horizontal, 4)

            HStack(spacing: 12) {
                tipoChip(.fisico,  icon: "creditcard.fill", label: "Físico")
                tipoChip(.virtual, icon: "iphone",          label: "Virtual")
            }
        }
    }

    private func tipoChip(_ tipo: TipoCartao, icon: String, label: String) -> some View {
        let selected = viewModel.tipo == tipo
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) { viewModel.tipo = tipo }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(selected ? .white : purple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(selected ? purple : purple.opacity(0.10))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selected ? Color.clear : purple.opacity(0.30), lineWidth: 1)
            )
            .shadow(color: selected ? purple.opacity(0.35) : .clear, radius: 8, x: 0, y: 4)
        }
    }

    // MARK: - Seção: Status

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Status", icon: "circle.fill")
                .padding(.horizontal, 4)

            HStack(spacing: 10) {
                statusChip(.ativo,     label: "Ativo",     cor: teal)
                statusChip(.bloqueado, label: "Bloqueado", cor: orange)
                statusChip(.cancelado, label: "Cancelado", cor: pink)
            }
        }
    }

    private func statusChip(_ status: StatusCartao, label: String, cor: Color) -> some View {
        let selected = viewModel.status == status
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) { viewModel.status = status }
        }) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(selected ? .white : cor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selected ? cor : cor.opacity(0.12))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(selected ? Color.clear : cor.opacity(0.35), lineWidth: 1))
                .shadow(color: selected ? cor.opacity(0.35) : .clear, radius: 6, x: 0, y: 3)
        }
    }

    // MARK: - Botão salvar

    private var salvarButton: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: {
                focusedField = nil
                viewModel.salvar()
                if viewModel.cartaoSalvo { dismiss() }
            }) {
                Text("Adicionar Cartão")
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

    private func inputRow(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        field: Field,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(purple)
                .frame(width: 20)
            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .keyboardType(keyboard)
                .focused($focusedField, equals: field)
                .autocapitalization(field == .nome ? .words : .none)
                .disableAutocorrection(true)
        }
    }

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
    CadastroCartaoView()
}
