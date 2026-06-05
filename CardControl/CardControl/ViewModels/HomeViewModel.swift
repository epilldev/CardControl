import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    @Published var cartoes: [Cartao] = []

    var resumo: ResumoFinanceiro {

        ResumoFinanceiro(
            totalGeral: cartoes.reduce(0) { $0 + $1.totalGasto },
            totalMesAtual: cartoes.reduce(0) { $0 + $1.gastosMesAtual },
            totalLimite: cartoes.reduce(0) { $0 + $1.limiteTotal },
            totalDisponivel: cartoes.reduce(0) { $0 + $1.limiteDisponivel }
        )
    }

    init() {
        carregarCartoes()
    }

    /// Responsável por carregar os cartões persistidos no Core Data.
    func carregarCartoes() {

        let entidades =
            CoreDataManager.shared.buscarCartoes()

        cartoes = entidades.map { entidade in

            Cartao(
                id: entidade.id ?? UUID(),
                nome: entidade.nome ?? "Sem nome",
                limiteTotal: entidade.limiteTotal,
                finalCartao: entidade.finalCartao ?? "",
                cvv: entidade.cvv ?? "",
                status: StatusCartao(
                    rawValue: entidade.status ?? "ativo"
                ) ?? .ativo,
                tipo: TipoCartao(
                    rawValue: entidade.tipo ?? "fisico"
                ) ?? .fisico,
                gastos: []
            )
        }
    }

    /// Responsável por remover um cartão da lista e do banco de dados local.
    func removerCartao(id: UUID) {

        CoreDataManager.shared.removerCartao(id: id)

        carregarCartoes()
    }
}
