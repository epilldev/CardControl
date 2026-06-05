import Foundation
import Combine

/// Responsável pelas regras de negócio da tela de cadastro de gastos.
final class CreateGastoViewModel: ObservableObject {

    @Published var descricao = ""
    @Published var estabelecimento = ""
    @Published var valor = ""

    @Published var data = Date()

    @Published var categoria: CategoriaGasto = .outros

    /// Responsável por cadastrar um novo gasto no banco de dados local.
    func salvarGasto(
        cartaoId: UUID
    ) {

        guard let valorDouble =
            Double(valor)
        else {
            return
        }

        CoreDataManager.shared.salvarGasto(
            valor: valorDouble,
            data: data,
            descricao: descricao,
            estabelecimento: estabelecimento,
            categoria: categoria.rawValue,
            cartaoId: cartaoId
        )
    }
}
