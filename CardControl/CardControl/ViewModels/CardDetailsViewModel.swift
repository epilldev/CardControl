import Foundation
import Combine

/// Responsável pelas regras de negócio da tela de detalhes do cartão.
final class CardDetailsViewModel: ObservableObject {

    /// Responsável por atualizar o status de um cartão.
    func atualizarStatus(
        cartao: Cartao,
        ativo: Bool
    ) {

        CoreDataManager.shared.atualizarCartao(
            id: cartao.id,
            limiteTotal: cartao.limiteTotal,
            status: ativo
                ? "ativo"
                : "bloqueado"
        )
    }

    /// Responsável por atualizar o limite de um cartão.
    func alterarLimite(
        cartao: Cartao,
        novoLimite: Double
    ) {

        CoreDataManager.shared.atualizarCartao(
            id: cartao.id,
            limiteTotal: novoLimite,
            status: cartao.status.rawValue
        )
    }
    
    func removerCartao(
        id: UUID
    ) {

        CoreDataManager.shared.removerCartao(
            id: id
        )
    }
}
