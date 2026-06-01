import Foundation

/// Representa uma transação realizada em um cartão de crédito.
struct Gasto: Identifiable {
    let id: UUID
    
    var valor: Double
    var data: Date
    
    var descricao: String
    
    var cartaoId: UUID
}
