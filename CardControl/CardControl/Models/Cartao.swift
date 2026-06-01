import Foundation

/// Representa um cartão de crédito associado ao usuário.
struct Cartao: Identifiable {
    let id: UUID
    
    var nome: String
    var limiteTotal: Double
    
    var finalCartao: String
    var cvv: String
    
    var status: StatusCartao
    var tipo: TipoCartao
    
    var gastos: [Gasto]
    
    var totalGasto: Double {
        gastos.reduce(0) { $0 + $1.valor }
    }
    
    var limiteDisponivel: Double {
        limiteTotal - totalGasto
    }
}
