import Foundation

enum StatusFatura: String, CaseIterable, Identifiable {
    case pendente = "Pendente"
    case paga     = "Paga"
    case atrasada = "Atrasada"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .pendente: return "clock.fill"
        case .paga:     return "checkmark.circle.fill"
        case .atrasada: return "exclamationmark.circle.fill"
        }
    }
}
