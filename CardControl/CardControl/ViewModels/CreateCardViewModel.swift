import Foundation
import Combine

/// Responsável pelas regras de negócio da tela de cadastro de cartões.
final class CreateCardViewModel: ObservableObject {

    @Published var nome = ""
    @Published var limiteTotal = ""
    @Published var finalCartao = ""
    @Published var cvv = ""

    @Published var cartaoVirtual = false

    /// Responsável por armazenar mensagens de erro de validação.
    @Published var mensagemErro = ""

    /// Responsável por validar os dados informados antes do cadastro.
    func validarDados() -> Bool {

        mensagemErro = ""

        let nomeTratado =
            nome.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !nomeTratado.isEmpty else {

            mensagemErro =
                "Informe o nome do cartão."

            return false
        }

        guard let limite =
                Double(
                    limiteTotal.replacingOccurrences(
                        of: ",",
                        with: "."
                    )
                ),
              limite > 0 else {

            mensagemErro =
                "Informe um limite válido maior que zero."

            return false
        }

        guard finalCartao.count == 4,
              finalCartao.allSatisfy(\.isNumber) else {

            mensagemErro =
                "O final do cartão deve possuir exatamente 4 números."

            return false
        }

        guard finalCartao != "0000" else {

            mensagemErro =
                "O final do cartão não pode ser 0000."

            return false
        }

        guard cvv.count == 3,
              cvv.allSatisfy(\.isNumber) else {

            mensagemErro =
                "O CVV deve possuir exatamente 3 números."

            return false
        }

        guard cvv != "000" else {

            mensagemErro =
                "Informe um CVV válido."

            return false
        }

        return true
    }

    /// Responsável por persistir um novo cartão no banco local.
    func salvarCartao() {

        let nomeTratado =
            nome.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard let limite =
                Double(
                    limiteTotal.replacingOccurrences(
                        of: ",",
                        with: "."
                    )
                ) else {
            return
        }

        CoreDataManager.shared.salvarCartao(
            nome: nomeTratado,
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
