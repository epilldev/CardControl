import Foundation
import Combine

final class CadastroCartaoViewModel: ObservableObject {

    @Published var nome = ""
    @Published var finalCartao = ""
    @Published var limite = ""
    @Published var tipo: TipoCartao = .fisico
    @Published var status: StatusCartao = .ativo
    @Published var cartaoSalvo = false

    var limiteNumerico: Double {
        Double(limite.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var formularioValido: Bool {
        !nome.trimmingCharacters(in: .whitespaces).isEmpty
            && finalCartao.count == 4
            && limiteNumerico > 0
    }

    func salvar() {
        guard formularioValido else { return }
        cartaoSalvo = true
    }
}
