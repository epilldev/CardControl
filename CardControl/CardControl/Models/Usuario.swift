import Foundation

/// Representa o usuário proprietário dos cartões cadastrados no sistema.
struct Usuario: Identifiable {

    let id: String

    var nome: String
    var email: String

    var cartoes: [Cartao]
}
