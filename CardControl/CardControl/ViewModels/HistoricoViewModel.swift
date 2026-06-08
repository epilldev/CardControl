import Foundation
import Combine

struct GastoComCartao: Identifiable {
    var id: UUID { gasto.id }
    let gasto: Gasto
    let cartao: Cartao
    let paletteIndex: Int
}

struct GrupoPorMes: Identifiable {
    let id: String
    let mes: Int
    let ano: Int
    let gastos: [GastoComCartao]

    var total: Double { gastos.reduce(0) { $0 + $1.gasto.valor } }

    var titulo: String {
        var components = DateComponents()
        components.month = mes
        components.year  = ano
        let date = Calendar.current.date(from: components) ?? Date()
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "MMMM 'de' yyyy"
        return f.string(from: date).capitalized
    }
}

final class HistoricoViewModel: ObservableObject {

    @Published var filtroCartaoId: UUID? = nil

    let cartoes: [Cartao]

    init(cartoes: [Cartao] = []) {
        self.cartoes = cartoes.isEmpty ? Self.mockCartoes() : cartoes
    }

    // MARK: - Computed

    private var todosGastos: [GastoComCartao] {
        cartoes.enumerated().flatMap { index, cartao in
            cartao.gastos.map { gasto in
                GastoComCartao(gasto: gasto, cartao: cartao, paletteIndex: index)
            }
        }
    }

    var gastosFiltrados: [GastoComCartao] {
        guard let filtroId = filtroCartaoId else { return todosGastos }
        return todosGastos.filter { $0.cartao.id == filtroId }
    }

    var gruposPorMes: [GrupoPorMes] {
        let calendar = Calendar.current
        let sorted = gastosFiltrados.sorted { $0.gasto.data > $1.gasto.data }

        var grupos: [String: [GastoComCartao]] = [:]
        for item in sorted {
            let m = calendar.component(.month, from: item.gasto.data)
            let a = calendar.component(.year,  from: item.gasto.data)
            let key = "\(a)-\(String(format: "%02d", m))"
            grupos[key, default: []].append(item)
        }

        return grupos.keys.sorted(by: >).compactMap { key in
            guard let items = grupos[key], let first = items.first else { return nil }
            let m = calendar.component(.month, from: first.gasto.data)
            let a = calendar.component(.year,  from: first.gasto.data)
            return GrupoPorMes(id: key, mes: m, ano: a, gastos: items)
        }
    }

    var totalGeral: Double {
        gastosFiltrados.reduce(0) { $0 + $1.gasto.valor }
    }

    var totalTransacoes: Int {
        gastosFiltrados.count
    }

    // MARK: - Mock

    private static func mockCartoes() -> [Cartao] {
        let id1 = UUID()
        let id2 = UUID()
        return [
            Cartao(
                id: id1, nome: "Nubank", limiteTotal: 3200, finalCartao: "4321", cvv: "123",
                status: .ativo, tipo: .fisico,
                gastos: [
                    Gasto(id: UUID(), valor: 850.00, data: Date(),                              descricao: "Supermercado Extra", cartaoId: id1),
                    Gasto(id: UUID(), valor: 320.50, data: Date().addingTimeInterval(-86400),    descricao: "iFood",             cartaoId: id1),
                    Gasto(id: UUID(), valor: 120.00, data: Date().addingTimeInterval(-86400*35), descricao: "Netflix",           cartaoId: id1),
                ]
            ),
            Cartao(
                id: id2, nome: "Inter", limiteTotal: 4000, finalCartao: "9876", cvv: "456",
                status: .ativo, tipo: .virtual,
                gastos: [
                    Gasto(id: UUID(), valor: 929.50, data: Date().addingTimeInterval(-86400*3),  descricao: "Amazon",   cartaoId: id2),
                    Gasto(id: UUID(), valor: 450.00, data: Date().addingTimeInterval(-86400*40), descricao: "Farmácia", cartaoId: id2),
                ]
            ),
        ]
    }
}
