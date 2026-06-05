import Foundation
import Combine

/// Responsável pelas regras de negócio da tela de cadastro de cartões.
final class CreateCardViewModel: ObservableObject {

    @Published var nome = ""
    @Published var limiteTotal = ""
    @Published var finalCartao = ""
    @Published var cvv = ""

    @Published var cartaoVirtual = false

    /// Responsável por cadastrar um novo cartão no banco de dados local.
    func salvarCartao() {

        guard let limite = Double(limiteTotal) else {
            return
        }

        CoreDataManager.shared.salvarCartao(
            nome: nome,
            limiteTotal: limite,
            finalCartao: finalCartao,
            cvv: cvv,
            status: "ativo",
            tipo: cartaoVirtual
                ? "virtual"
                : "fisico"
        )
    }
}
