import Foundation
import Combine

/// Responsável pelas regras de negócio da tela de cadastro de gastos.
final class CreateGastoViewModel: ObservableObject {

    @Published var descricao = ""
    @Published var estabelecimento = ""
    @Published var valor = ""

    @Published var data = Date()

    @Published var categoria: CategoriaGasto = .outros

    /// Responsável por armazenar mensagens de erro de validação.
    @Published var mensagemErro = ""

    /// Responsável por validar os dados informados antes do cadastro.
    func validarDados() -> Bool {

        mensagemErro = ""

        let descricaoTratada =
            descricao.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let estabelecimentoTratado =
            estabelecimento.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !descricaoTratada.isEmpty else {

            mensagemErro =
                "Informe a descrição do gasto."

            return false
        }

        guard !estabelecimentoTratado.isEmpty else {

            mensagemErro =
                "Informe o estabelecimento."

            return false
        }

        guard let valorDouble =
                Double(
                    valor.replacingOccurrences(
                        of: ",",
                        with: "."
                    )
                ),
              valorDouble > 0 else {

            mensagemErro =
                "Informe um valor válido maior que zero."

            return false
        }

        return true
    }

    /// Responsável por cadastrar um novo gasto no banco de dados local.
    func salvarGasto(
        cartaoId: UUID
    ) {

        let descricaoTratada =
            descricao.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let estabelecimentoTratado =
            estabelecimento.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard let valorDouble =
                Double(
                    valor.replacingOccurrences(
                        of: ",",
                        with: "."
                    )
                ) else {
            return
        }

        CoreDataManager.shared.salvarGasto(
            valor: valorDouble,
            data: data,
            descricao: descricaoTratada,
            estabelecimento: estabelecimentoTratado,
            categoria: categoria.rawValue,
            cartaoId: cartaoId
        )
    }
}
