import SwiftUI

// MARK: - Paleta global

private extension Color {
    static let brandPurple  = Color(red: 0.42, green: 0.17, blue: 0.88)
    static let brandDeep    = Color(red: 0.10, green: 0.03, blue: 0.35)
    static let brandPink    = Color(red: 0.95, green: 0.24, blue: 0.57)
    static let brandOrange  = Color(red: 1.00, green: 0.57, blue: 0.15)
    static let brandTeal    = Color(red: 0.07, green: 0.75, blue: 0.58)
    static let pageBackground = Color(red: 0.96, green: 0.94, blue: 1.00)
}

// MARK: - HomeView

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.pageBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerBanner
                    VStack(alignment: .leading, spacing: 28) {
                        resumoFinanceiro
                        listaCartoes
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        CreateCardView()
                    } label: {
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.brandPurple)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    }
                    .padding()
                }
            }
            
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.carregarCartoes()
        }
        
    }
    
    // MARK: - Header
    
    private var headerBanner: some View {
        ZStack {
            LinearGradient(
                colors: [.brandPurple, .brandDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Circle()
                .fill(Color.brandPink.opacity(0.3))
                .frame(width: 220)
                .offset(x: 130, y: -10)
                .blur(radius: 50)
            
            Circle()
                .fill(Color.brandOrange.opacity(0.15))
                .frame(width: 160)
                .offset(x: -80, y: 40)
                .blur(radius: 40)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Olá (Usuário)")
                    //Text("Olá, \(viewModel.usuario.nome) 👋")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Text(dataFormatada)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))
                }
                Spacer()
                avatarInicial
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .padding(.bottom, 28)
        }
    }
    
    private var avatarInicial: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [.brandPink, .brandOrange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 50, height: 50)
            Text("U")
            //Text(String(viewModel.usuario.nome.prefix(1)))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .shadow(color: Color.brandPink.opacity(0.5), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Resumo Financeiro
    
    private var resumoFinanceiro: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                statTile(
                    titulo: "Gasto Total",
                    valor: viewModel.resumo.totalGeral.moeda,
                    icon: "arrow.up.circle.fill",
                    colors: [.brandPink, Color(red: 0.72, green: 0.10, blue: 0.38)]
                )
                statTile(
                    titulo: "Disponível",
                    valor: viewModel.resumo.totalDisponivel.moeda,
                    icon: "checkmark.circle.fill",
                    colors: [.brandTeal, Color(red: 0.02, green: 0.50, blue: 0.40)]
                )
            }
            HStack(spacing: 12) {
                statTile(
                    titulo: "Limite Total",
                    valor: viewModel.resumo.totalLimite.moeda,
                    icon: "creditcard.fill",
                    colors: [.brandPurple, .brandDeep]
                )
                statTile(
                    titulo: "Gasto no Mês",
                    valor: viewModel.resumo.totalMesAtual.moeda,
                    icon: "calendar.circle.fill",
                    colors: [.brandOrange, Color(red: 0.85, green: 0.38, blue: 0.00)]
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
        .shadow(color: colors.first!.opacity(0.4), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Lista de Cartões
    
    private var listaCartoes: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Meus Cartões")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.12, green: 0.06, blue: 0.28))
            
            VStack(spacing: 18) {
                
                ForEach(Array(viewModel.cartoes.enumerated()), id: \.element.id) { index, cartao in
                    
                    NavigationLink {
                        
                        CardDetailsView(cartao: cartao)
                        
                    } label: {
                        
                        CartaoCard(
                            cartao: cartao,
                            paletteIndex: index
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                
            }
        }
    }
    
    // MARK: - Helpers
    
    private var dataFormatada: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "EEEE, d 'de' MMMM"
        return f.string(from: Date()).capitalized
    }
}

// MARK: - Paleta dos cartões

private let cardPalettes: [[Color]] = [
    [Color(red: 0.42, green: 0.17, blue: 0.88), Color(red: 0.10, green: 0.03, blue: 0.40)],
    [Color(red: 1.00, green: 0.45, blue: 0.10), Color(red: 0.90, green: 0.18, blue: 0.50)],
    [Color(red: 0.14, green: 0.17, blue: 0.35), Color(red: 0.06, green: 0.08, blue: 0.20)],
]

// MARK: - CartaoCard

private struct CartaoCard: View {
    
    let cartao: Cartao
    let paletteIndex: Int
    
    private var gradientColors: [Color] { cardPalettes[paletteIndex % cardPalettes.count] }
    
    var body: some View {
        VStack(spacing: 0) {
            cardFront
            cardDetails
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: gradientColors.first!.opacity(0.35), radius: 16, x: 0, y: 8)
    }
    
    // MARK: Visual do cartão (frente)
    
    private var cardFront: some View {
        ZStack {
            LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
            
            Circle()
                .fill(.white.opacity(0.07))
                .frame(width: 180)
                .offset(x: 110, y: -25)
            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 140)
                .offset(x: 140, y: 55)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(cartao.nome)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    statusBadge
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.yellow.opacity(0.85))
                    Spacer()
                    tipoBadge
                }
                
                Spacer().frame(height: 10)
                
                Text("•••• •••• •••• \(cartao.finalCartao)")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.9))
                    .tracking(2)
            }
            .padding(20)
        }
        .frame(height: 140)
    }
    
    private var tipoBadge: some View {
        Text(cartao.tipo == .virtual ? "Virtual" : "Físico")
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.white.opacity(0.2))
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
    
    // MARK: Detalhes abaixo do cartão
    
    private var cardDetails: some View {
        VStack(spacing: 12) {
            barraDeLimite
            Divider()
            rodape
        }
        .padding(16)
        .background(.white)
    }
    
    private var barraDeLimite: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Limite utilizado")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(cartao.percentualUsado * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(corBarra)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(LinearGradient(
                            colors: [corBarra.opacity(0.7), corBarra],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(
                            width: max(geo.size.width * cartao.percentualUsado, cartao.percentualUsado > 0 ? 8 : 0),
                            height: 8
                        )
                }
            }
            .frame(height: 8)
            
            HStack {
                Text("Gasto: " + cartao.totalGasto.moeda)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Limite: " + cartao.limiteTotal.moeda)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var corBarra: Color {
        switch cartao.percentualUsado {
        case ..<0.60:  return Color(red: 0.07, green: 0.75, blue: 0.58)
        case ..<0.85:  return Color(red: 1.00, green: 0.57, blue: 0.15)
        default:       return Color(red: 0.95, green: 0.24, blue: 0.57)
        }
    }
    
    private var rodape: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Disponível")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(cartao.limiteDisponivel.moeda)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.06, blue: 0.28))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("Transações")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("\(cartao.gastos.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.06, blue: 0.28))
            }
        }
    }
}

// MARK: - Double Extension

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
        HomeView()
    }
}
