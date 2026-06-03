import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    @Published var usuario: Usuario

    var resumo: ResumoFinanceiro {
        let cartoes = usuario.cartoes
        return ResumoFinanceiro(
            totalGeral: cartoes.reduce(0) { $0 + $1.totalGasto },
            totalMesAtual: cartoes.reduce(0) { $0 + $1.gastosMesAtual },
            totalLimite: cartoes.reduce(0) { $0 + $1.limiteTotal },
            totalDisponivel: cartoes.reduce(0) { $0 + $1.limiteDisponivel }
        )
    }

    init() {
        let agora = Date()
        let umDiaAtras = agora.addingTimeInterval(-86400)
        let tresdiasAtras = agora.addingTimeInterval(-86400 * 3)

        let cartao1 = Cartao(
            id: UUID(),
            nome: "Nubank",
            limiteTotal: 3200,
            finalCartao: "4321",
            cvv: "123",
            status: .ativo,
            tipo: .fisico,
            gastos: [
                Gasto(id: UUID(), valor: 850.00, data: agora, descricao: "Supermercado Extra", cartaoId: UUID()),
                Gasto(id: UUID(), valor: 320.50, data: umDiaAtras, descricao: "iFood", cartaoId: UUID()),
                Gasto(id: UUID(), valor: 929.50, data: tresdiasAtras, descricao: "Amazon", cartaoId: UUID())
            ]
        )

        let cartao2 = Cartao(
            id: UUID(),
            nome: "Inter",
            limiteTotal: 4000,
            finalCartao: "9876",
            cvv: "456",
            status: .ativo,
            tipo: .virtual,
            gastos: [
                Gasto(id: UUID(), valor: 650.00, data: agora, descricao: "Netflix + Spotify", cartaoId: UUID()),
                Gasto(id: UUID(), valor: 500.00, data: umDiaAtras, descricao: "Passagem aérea", cartaoId: UUID())
            ]
        )

        let cartao3 = Cartao(
            id: UUID(),
            nome: "XP Visa",
            limiteTotal: 8000,
            finalCartao: "1234",
            cvv: "789",
            status: .bloqueado,
            tipo: .fisico,
            gastos: []
        )

        self.usuario = Usuario(
            id: UUID(),
            nome: "Camila",
            email: "camila@email.com",
            cartoes: [cartao1, cartao2, cartao3]
        )
    }
}
