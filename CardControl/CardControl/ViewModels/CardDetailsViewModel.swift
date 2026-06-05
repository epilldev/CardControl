import Foundation
import Combine

/// Responsável pelas regras de negócio da tela de detalhes do cartão.
final class CardDetailsViewModel: ObservableObject {

    @Published var gastos: [Gasto] = []

    /// Responsável por carregar os gastos de um cartão.
    func carregarGastos(
        cartaoId: UUID
    ) {

        let entidades =
            CoreDataManager.shared.buscarGastos(
                cartaoId: cartaoId
            )

        gastos = entidades.map { entidade in

            Gasto(
                id: entidade.id ?? UUID(),
                valor: entidade.valor,
                data: entidade.data ?? Date(),
                descricao: entidade.descricao ?? "",
                estabelecimento: entidade.estabelecimento ?? "",
                categoria: CategoriaGasto(
                    rawValue: entidade.categoria ?? ""
                ) ?? .outros,
                cartaoId: cartaoId
            )
        }
    }

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

    /// Responsável por remover um cartão.
    func removerCartao(
        id: UUID
    ) {

        CoreDataManager.shared.removerCartao(
            id: id
        )
    }

    /// Responsável por remover um gasto.
    func removerGasto(
        id: UUID,
        cartaoId: UUID
    ) {

        CoreDataManager.shared.removerGasto(
            id: id
        )

        carregarGastos(
            cartaoId: cartaoId
        )
    }
}
