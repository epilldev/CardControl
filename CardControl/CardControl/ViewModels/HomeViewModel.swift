import Foundation
import Combine

/// Responsável pelas informações exibidas na tela inicial do aplicativo.
final class HomeViewModel: ObservableObject {

    @Published var cartoes: [Cartao] = [
        Cartao(
            id: UUID(),
            nome: "Cartão Principal",
            limiteTotal: 5000,
            finalCartao: "1234",
            cvv: "123",
            status: .ativo,
            tipo: .fisico,
            gastos: []
        ),

        Cartao(
            id: UUID(),
            nome: "Cartão Viagem",
            limiteTotal: 8000,
            finalCartao: "5678",
            cvv: "456",
            status: .ativo,
            tipo: .virtual,
            gastos: []
        )
    ]
}
