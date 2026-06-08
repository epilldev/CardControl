import Foundation

/// Representa uma fatura mensal de um cartão de crédito.
struct Fatura: Identifiable {
    let id: UUID
    var cartaoId: UUID
    var valor: Double
    var vencimento: Date
    var mesReferencia: Int
    var anoReferencia: Int
    var status: StatusFatura
    var observacao: String
}
