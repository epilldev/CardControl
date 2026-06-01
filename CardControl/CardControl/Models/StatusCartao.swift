import Foundation

/// Representa o status atual do cartão no sistema.
enum StatusCartao: String, Codable {
    case ativo
    case bloqueado
    case cancelado
}
