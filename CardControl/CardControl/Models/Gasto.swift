import Foundation

struct Gasto: Identifiable {
    
    /// Representa uma transação realizada em um cartão de crédito.
    let id: UUID
    
    var valor: Double
    var data: Date
    
    var descricao: String
    
    var estabelecimento: String
    
    var categoria: CategoriaGasto
    
    var cartaoId: UUID
}
