import Foundation
import Combine

final class FaturaViewModel: ObservableObject {

    @Published var cartaoSelecionado: Cartao?
    @Published var valor = ""
    @Published var vencimento = Date()
    @Published var mesReferencia: Int
    @Published var anoReferencia: Int
    @Published var status: StatusFatura = .pendente
    @Published var observacao = ""
    @Published var faturaSalva = false

    let cartoes: [Cartao]

    init(cartoes: [Cartao] = []) {
        self.cartoes = cartoes.isEmpty ? Self.mockCartoes() : cartoes
        let hoje = Date()
        self.mesReferencia = Calendar.current.component(.month, from: hoje)
        self.anoReferencia = Calendar.current.component(.year, from: hoje)
    }

    // MARK: - Computed

    var valorNumerico: Double {
        Double(valor.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var formularioValido: Bool {
        cartaoSelecionado != nil && valorNumerico > 0
    }

    var mesReferenciaNome: String {
        var components = DateComponents()
        components.month = mesReferencia
        components.year  = anoReferencia
        let date = Calendar.current.date(from: components) ?? Date()
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "MMMM"
        return f.string(from: date).capitalized
    }

    // MARK: - Ações

    func avancarMes() {
        var m = mesReferencia + 1
        var a = anoReferencia
        if m > 12 { m = 1; a += 1 }
        mesReferencia = m
        anoReferencia = a
    }

    func retrocederMes() {
        var m = mesReferencia - 1
        var a = anoReferencia
        if m < 1 { m = 12; a -= 1 }
        mesReferencia = m
        anoReferencia = a
    }

    func salvar() {
        guard formularioValido else { return }
        faturaSalva = true
    }

    // MARK: - Mock

    private static func mockCartoes() -> [Cartao] {
        [
            Cartao(id: UUID(), nome: "Nubank",  limiteTotal: 3200, finalCartao: "4321", cvv: "123", status: .ativo,     tipo: .fisico,   gastos: []),
            Cartao(id: UUID(), nome: "Inter",   limiteTotal: 4000, finalCartao: "9876", cvv: "456", status: .ativo,     tipo: .virtual,  gastos: []),
            Cartao(id: UUID(), nome: "XP Visa", limiteTotal: 8000, finalCartao: "1234", cvv: "789", status: .bloqueado, tipo: .fisico,   gastos: [])
        ]
    }
}
