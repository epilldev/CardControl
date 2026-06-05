import Foundation
import Combine

final class DespesaViewModel: ObservableObject {

    // MARK: - Categoria

    enum Categoria: String, CaseIterable, Identifiable {
        case alimentacao = "Alimentação"
        case transporte  = "Transporte"
        case saude       = "Saúde"
        case lazer       = "Lazer"
        case assinaturas = "Assinaturas"
        case compras     = "Compras"
        case outros      = "Outros"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .alimentacao: return "fork.knife"
            case .transporte:  return "car.fill"
            case .saude:       return "heart.fill"
            case .lazer:       return "gamecontroller.fill"
            case .assinaturas: return "play.rectangle.fill"
            case .compras:     return "bag.fill"
            case .outros:      return "ellipsis.circle.fill"
            }
        }
    }

    // MARK: - Form state

    @Published var descricao = ""
    @Published var valor = ""
    @Published var data = Date()
    @Published var categoriaSelecionada: Categoria = .outros
    @Published var cartaoSelecionado: Cartao?
    @Published var despesaSalva = false

    let cartoes: [Cartao]

    init(cartoes: [Cartao] = []) {
        self.cartoes = cartoes.isEmpty ? Self.mockCartoes() : cartoes
    }

    // MARK: - Validação

    var valorNumerico: Double {
        Double(valor.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var formularioValido: Bool {
        !descricao.trimmingCharacters(in: .whitespaces).isEmpty
            && valorNumerico > 0
            && cartaoSelecionado != nil
    }

    // MARK: - Ação

    func salvar() {
        guard formularioValido else { return }
        despesaSalva = true
    }

    // MARK: - Mock

    private static func mockCartoes() -> [Cartao] {
        [
            Cartao(id: UUID(), nome: "Nubank",  limiteTotal: 3200, finalCartao: "4321", cvv: "123", status: .ativo,    tipo: .fisico,   gastos: []),
            Cartao(id: UUID(), nome: "Inter",   limiteTotal: 4000, finalCartao: "9876", cvv: "456", status: .ativo,    tipo: .virtual,  gastos: []),
            Cartao(id: UUID(), nome: "XP Visa", limiteTotal: 8000, finalCartao: "1234", cvv: "789", status: .bloqueado, tipo: .fisico,  gastos: [])
        ]
    }
}
