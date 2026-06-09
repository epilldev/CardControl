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
    
    var total: Double {
        gastos.reduce(0) { $0 + $1.gasto.valor }
    }
    
    var titulo: String {
        var components = DateComponents()
        components.month = mes
        components.year = ano
        
        let date = Calendar.current.date(from: components) ?? Date()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMMM 'de' yyyy"
        
        return formatter.string(from: date).capitalized
    }
}

final class HistoricoViewModel: ObservableObject {
    
    @Published var filtroCartaoId: UUID? = nil
    
    let cartoes: [Cartao]
    
    init(cartoes: [Cartao] = []) {
        self.cartoes = cartoes
    }
    
    // MARK: - Computed Properties
    
    private var todosGastos: [GastoComCartao] {
        cartoes.enumerated().flatMap { index, cartao in
            cartao.gastos.map { gasto in
                GastoComCartao(
                    gasto: gasto,
                    cartao: cartao,
                    paletteIndex: index
                )
            }
        }
    }
    
    var gastosFiltrados: [GastoComCartao] {
        guard let filtroId = filtroCartaoId else {
            return todosGastos
        }
        
        return todosGastos.filter { $0.cartao.id == filtroId }
    }
    
    var gruposPorMes: [GrupoPorMes] {
        let calendar = Calendar.current
        let sorted = gastosFiltrados.sorted { $0.gasto.data > $1.gasto.data }
        
        var grupos: [String: [GastoComCartao]] = [:]
        
        for item in sorted {
            let mes = calendar.component(.month, from: item.gasto.data)
            let ano = calendar.component(.year, from: item.gasto.data)
            
            let key = "\(ano)-\(String(format: "%02d", mes))"
            
            grupos[key, default: []].append(item)
        }
        
        return grupos.keys
            .sorted(by: >)
            .compactMap { key in
                guard
                    let items = grupos[key],
                    let first = items.first
                else {
                    return nil
                }
                
                let mes = calendar.component(.month, from: first.gasto.data)
                let ano = calendar.component(.year, from: first.gasto.data)
                
                return GrupoPorMes(
                    id: key,
                    mes: mes,
                    ano: ano,
                    gastos: items
                )
            }
    }
    
    var totalGeral: Double {
        gastosFiltrados.reduce(0) { $0 + $1.gasto.valor }
    }
    
    var totalTransacoes: Int {
        gastosFiltrados.count
    }
}
