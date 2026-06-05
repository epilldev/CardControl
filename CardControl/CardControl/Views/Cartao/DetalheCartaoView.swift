import SwiftUI

struct DetalheCartaoView: View {
    
    let cartao: Cartao
    var paletteIndex: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    
    private let paletas: [[Color]] = [
        [Color(red: 0.42, green: 0.17, blue: 0.88), Color(red: 0.10, green: 0.03, blue: 0.40)],
        [Color(red: 1.00, green: 0.45, blue: 0.10), Color(red: 0.90, green: 0.18, blue: 0.50)],
        [Color(red: 0.14, green: 0.17, blue: 0.35), Color(red: 0.06, green: 0.08, blue: 0.20)],
    ]
    
    private var coresCartao: [Color] { paletas[paletteIndex % paletas.count] }
    
    private let pageBackground = Color(red: 0.96, green: 0.94, blue: 1.00)
    private let pink           = Color(red: 0.95, green: 0.24, blue: 0.57)
    private let teal           = Color(red: 0.07, green: 0.75, blue: 0.58)
    private let purple         = Color(red: 0.42, green: 0.17, blue: 0.88)
    private let orange         = Color(red: 1.00, green: 0.57, blue: 0.15)
    private let darkText       = Color(red: 0.12, green: 0.06, blue: 0.28)
    
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
            LinearGradient(colors: coresCartao, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top)
            
            Circle()
                .fill(.white.opacity(0.07))
                .frame(width: 260)
                .offset(x: 140, y: -40)
                .blur(radius: 50)
            
            Circle()
                .fill(.white.opacity(0.04))
                .frame(width: 180)
                .offset(x: -60, y: 60)
                .blur(radius: 40)
            
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
                    Text(cartao.nome)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Color.clear.frame(width: 34, height: 34)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer().frame(height: 20)
                
                cartaoVisual
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 28)
            }
        }
    }
    
    private var cartaoVisual: some View {
        ZStack {
            LinearGradient(colors: coresCartao, startPoint: .topLeading, endPoint: .bottomTrailing)
            
            Circle().fill(.white.opacity(0.08)).frame(width: 210).offset(x: 115, y: -35)
            Circle().fill(.white.opacity(0.05)).frame(width: 160).offset(x: 145, y: 65)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(cartao.nome)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    statusBadge
                }
                Spacer()
                HStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.yellow.opacity(0.85))
                    Spacer()
                    tipoBadge
                }
                Spacer().frame(height: 12)
                Text("•••• •••• •••• \(cartao.finalCartao)")
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.9))
                    .tracking(2.5)
            }
            .padding(22)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.28), radius: 22, x: 0, y: 10)
    }
    
    private var tipoBadge: some View {
        Text(cartao.tipo == .virtual ? "Virtual" : "Físico")
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.white.opacity(0.20))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
    
    private var statusBadge: some View {
        let (label, cor) = statusInfo
        return Text(label)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(cor.opacity(0.25))
            .foregroundColor(cor)
            .clipShape(Capsule())
    }
    
    private var statusInfo: (String, Color) {
        switch cartao.status {
        case .ativo:     return ("Ativo",     Color(red: 0.25, green: 1.00, blue: 0.65))
        case .bloqueado: return ("Bloqueado", Color(red: 1.00, green: 0.78, blue: 0.15))
        case .cancelado: return ("Cancelado", Color(red: 1.00, green: 0.38, blue: 0.38))
        }
    }
    
    // MARK: - Corpo
    
    private var corpo: some View {
        VStack(alignment: .leading, spacing: 28) {
            statTiles
            progressSection
            transacoesSection
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 44)
    }
    
    // MARK: - Stat Tiles
    
    private var statTiles: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                statTile(
                    titulo: "Gasto Total",
                    valor: cartao.totalGasto.moeda,
                    icon: "arrow.up.circle.fill",
                    colors: [pink, Color(red: 0.72, green: 0.10, blue: 0.38)]
                )
                statTile(
                    titulo: "Disponível",
                    valor: cartao.limiteDisponivel.moeda,
                    icon: "checkmark.circle.fill",
                    colors: [teal, Color(red: 0.02, green: 0.50, blue: 0.40)]
                )
            }
            HStack(spacing: 12) {
                statTile(
                    titulo: "Limite Total",
                    valor: cartao.limiteTotal.moeda,
                    icon: "creditcard.fill",
                    colors: [purple, Color(red: 0.10, green: 0.03, blue: 0.40)]
                )
                statTile(
                    titulo: "Gasto no Mês",
                    valor: cartao.gastosMesAtual.moeda,
                    icon: "calendar.circle.fill",
                    colors: [orange, Color(red: 0.85, green: 0.38, blue: 0.00)]
                )
            }
        }
    }
    
    private func statTile(titulo: String, valor: String, icon: String, colors: [Color]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.9))
            VStack(alignment: .leading, spacing: 3) {
                Text(titulo)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.75))
                Text(valor)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: colors.first!.opacity(0.40), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Progresso de limite
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("Limite Utilizado")
            
            VStack(spacing: 10) {
                HStack {
                    Text("\(Int(cartao.percentualUsado * 100))% utilizado")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(corBarra)
                    Spacer()
                    Text(cartao.totalGasto.moeda + " / " + cartao.limiteTotal.moeda)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                            .frame(height: 12)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(
                                colors: [corBarra.opacity(0.7), corBarra],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(
                                width: max(geo.size.width * cartao.percentualUsado, cartao.percentualUsado > 0 ? 12 : 0),
                                height: 12
                            )
                    }
                }
                .frame(height: 12)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }
    
    private var corBarra: Color {
        switch cartao.percentualUsado {
        case ..<0.60: return teal
        case ..<0.85: return orange
        default:      return pink
        }
    }
    
    // MARK: - Transações
    
    private var transacoesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                sectionHeader("Transações")
                Spacer()
                Text("\(cartao.gastos.count) \(cartao.gastos.count == 1 ? "registro" : "registros")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if gastosOrdenados.isEmpty {
                emptyState
            } else {
                VStack(spacing: 0) {
                    ForEach(gastosOrdenados) { gasto in
                        transacaoRow(gasto)
                        if gasto.id != gastosOrdenados.last?.id {
                            Divider()
                                .padding(.leading, 74)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
            }
        }
    }
    
    private var gastosOrdenados: [Gasto] {
        cartao.gastos.sorted { $0.data > $1.data }
    }
    
    private func transacaoRow(_ gasto: Gasto) -> some View {
        HStack(spacing: 14) {
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
                Text(gasto.descricao)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(darkText)
                    .lineLimit(1)
                Text(gasto.data.formatada)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("-" + gasto.valor.moeda)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(pink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
    
    private var emptyState: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(purple.opacity(0.08))
                    .frame(width: 72, height: 72)
                Image(systemName: "tray.fill")
                    .font(.system(size: 28))
                    .foregroundColor(purple.opacity(0.4))
            }
            Text("Nenhuma transação registrada")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Text("As despesas deste cartão\naparecerão aqui.")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 44)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
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
    var formatada: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "d 'de' MMM 'de' yyyy"
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
    
    let gastos = [
        
        Gasto(
            id: UUID(),
            valor: 850.00,
            data: Date(),
            descricao: "Compra de Mercado",
            estabelecimento: "Supermercado Extra",
            categoria: .alimentacao,
            cartaoId: UUID()
        ),
        
        Gasto(
            id: UUID(),
            valor: 320.50,
            data: Date().addingTimeInterval(-86400),
            descricao: "Pedido de Comida",
            estabelecimento: "iFood",
            categoria: .alimentacao,
            cartaoId: UUID()
        ),
        
        Gasto(
            id: UUID(),
            valor: 929.50,
            data: Date().addingTimeInterval(-86400 * 3),
            descricao: "Eletrônicos",
            estabelecimento: "Amazon",
            categoria: .compras,
            cartaoId: UUID()
        )
    ]
    
    let cartao = Cartao(
        id: UUID(),
        nome: "Nubank",
        limiteTotal: 3200,
        finalCartao: "4321",
        cvv: "123",
        status: .ativo,
        tipo: .fisico,
        gastos: gastos
    )
    
    NavigationStack {
        
        DetalheCartaoView(
            cartao: cartao,
            paletteIndex: 0
        )
    }
}
