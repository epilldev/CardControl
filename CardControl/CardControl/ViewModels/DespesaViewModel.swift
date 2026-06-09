import Foundation
import Combine

final class DespesaViewModel: ObservableObject {

    // MARK: - Categoria

    enum Categoria: String, CaseIterable, Identifiable {

        case alimentacao = "Alimentação"
        case transporte = "Transporte"
        case saude = "Saúde"
        case lazer = "Lazer"
        case assinaturas = "Assinaturas"
        case compras = "Compras"
        case outros = "Outros"

        var id: String {
            rawValue
        }

        var icon: String {

            switch self {

            case .alimentacao:
                return "fork.knife"

            case .transporte:
                return "car.fill"

            case .saude:
                return "heart.fill"

            case .lazer:
                return "gamecontroller.fill"

            case .assinaturas:
                return "play.rectangle.fill"

            case .compras:
                return "bag.fill"

            case .outros:
                return "ellipsis.circle.fill"
            }
        }
    }

    // MARK: - Form State

    @Published var descricao = ""
    @Published var valor = ""
    @Published var data = Date()

    @Published var categoriaSelecionada: Categoria = .outros

    @Published var cartaoSelecionado: Cartao?

    @Published var despesaSalva = false

    @Published var cartoes: [Cartao] = []

    init() {

        carregarCartoes()
    }

    // MARK: - Validação

    var valorNumerico: Double {

        Double(
            valor.replacingOccurrences(
                of: ",",
                with: "."
            )
        ) ?? 0
    }

    var formularioValido: Bool {

        !descricao
            .trimmingCharacters(
                in: .whitespaces
            )
            .isEmpty
        && valorNumerico > 0
        && cartaoSelecionado != nil
    }

    // MARK: - Ações

    func carregarCartoes() {

        let entidades =
            CoreDataManager.shared.buscarCartoes()

        cartoes = entidades.map { entidade in

            Cartao(
                id: entidade.id ?? UUID(),
                nome: entidade.nome ?? "",
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

    func salvar() {

        guard formularioValido else {
            return
        }

        despesaSalva = true
    }
}
