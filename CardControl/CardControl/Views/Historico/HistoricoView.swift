import SwiftUI

struct HistoricoView: View {

    @StateObject private var viewModel: HistoricoViewModel
    @Environment(\.dismiss) private var dismiss

    private let pageBackground = Color(red: 0.96, green: 0.94, blue: 1.00)
    private let darkBlue       = Color(red: 0.14, green: 0.17, blue: 0.35)
    private let deepBlue       = Color(red: 0.06, green: 0.08, blue: 0.20)
    private let teal           = Color(red: 0.07, green: 0.75, blue: 0.58)
    private let purple         = Color(red: 0.42, green: 0.17, blue: 0.88)
    private let pink           = Color(red: 0.95, green: 0.24, blue: 0.57)
    private let darkText       = Color(red: 0.12, green: 0.06, blue: 0.28)

    private let paletas: [[Color]] = [
        [Color(red: 0.42, green: 0.17, blue: 0.88), Color(red: 0.10, green: 0.03, blue: 0.40)],
        [Color(red: 1.00, green: 0.45, blue: 0.10), Color(red: 0.90, green: 0.18, blue: 0.50)],
        [Color(red: 0.14, green: 0.17, blue: 0.35), Color(red: 0.06, green: 0.08, blue: 0.20)],
    ]

    init(cartoes: [Cartao] = []) {
        _viewModel = StateObject(wrappedValue: HistoricoViewModel(cartoes: cartoes))
    }

    var body: some View {
        ZStack(alignment: .top) {
            pageBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    cabecalho
                    corpo
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Cabeçalho

    private var cabecalho: some View {
        ZStack {
            LinearGradient(colors: [darkBlue, deepBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top)

            Circle()
                .fill(teal.opacity(0.20))
                .frame(width: 220)
                .offset(x: 130, y: -15)
                .blur(radius: 55)

            Circle()
                .fill(purple.opacity(0.15))
                .frame(width: 160)
                .offset(x: -70, y: 55)
                .blur(radius: 45)

            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(10)
                            .background(.white.opacity(0.18))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Histórico")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 34, height: 34)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer().frame(height: 20)

                resumoHeader
                    .padding(.horizontal, 20)

                Spacer().frame(height: 24)
            }
        }
    }

    private var resumoHeader: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Gasto")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.65))
                Text(viewModel.totalGeral.moeda)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Spacer()

            Rectangle()
                .fill(.white.opacity(0.20))
                .frame(width: 1, height: 40)

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("Transações")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.65))
                Text("\(viewModel.totalTransacoes)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(.white.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Corpo

    private var corpo: some View {
        VStack(alignment: .leading, spacing: 24) {
            filtrosSection

            if viewModel.gruposPorMes.isEmpty {
                emptyState
            } else {
                listaSection
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 44)
    }

    // MARK: - Filtros

    private var filtrosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Filtrar por Cartão")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    filtroChip(id: nil, label: "Todos", color: purple)

                    ForEach(Array(viewModel.cartoes.enumerated()), id: \.element.id) { index, cartao in
                        filtroChip(
                            id: cartao.id,
                            label: cartao.nome,
                            color: paletas[index % paletas.count].first!
                        )
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 2)
            }
        }
    }

    private func filtroChip(id: UUID?, label: String, color: Color) -> some View {
        let selected = viewModel.filtroCartaoId == id
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.filtroCartaoId = id
            }
        }) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(selected ? .white : color)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(selected ? color : color.opacity(0.12))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(selected ? Color.clear : color.opacity(0.35), lineWidth: 1))
                .shadow(color: selected ? color.opacity(0.35) : .clear, radius: 6, x: 0, y: 3)
        }
    }

    // MARK: - Lista agrupada

    private var listaSection: some View {
        VStack(spacing: 20) {
            ForEach(viewModel.gruposPorMes) { grupo in
                grupoSection(grupo)
            }
        }
    }

    private func grupoSection(_ grupo: GrupoPorMes) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(grupo.titulo)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(darkText)
                Spacer()
                Text(grupo.total.moeda)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(pink)
            }

            VStack(spacing: 0) {
                ForEach(grupo.gastos) { item in
                    gastoRow(item)
                    if item.id != grupo.gastos.last?.id {
                        Divider().padding(.leading, 74)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    private func gastoRow(_ item: GastoComCartao) -> some View {
        let paletteColor = paletas[item.paletteIndex % paletas.count].first!

        return HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [pink.opacity(0.12), pink.opacity(0.22)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 46, height: 46)
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(pink)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(item.gasto.descricao)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(darkText)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(item.gasto.data.formatadaHistorico)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(item.cartao.nome)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(paletteColor)
                }
            }

            Spacer()

            Text("-" + item.gasto.valor.moeda)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(pink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(darkBlue.opacity(0.08))
                    .frame(width: 72, height: 72)
                Image(systemName: "tray.fill")
                    .font(.system(size: 28))
                    .foregroundColor(darkBlue.opacity(0.35))
            }
            Text("Nenhuma transação encontrada")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Text("As transações dos seus\ncartões aparecerão aqui.")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(darkText)
    }
}

// MARK: - Extensions

private extension Date {
    var formatadaHistorico: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "d 'de' MMM"
        return f.string(from: self)
    }
}

private extension Double {
    var moeda: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "pt_BR")
        return f.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }
}

#Preview {
    NavigationStack {
        HistoricoView()
    }
}
