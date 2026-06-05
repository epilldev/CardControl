import Foundation

/// Representa um cartão de crédito associado ao usuário.
struct Cartao: Identifiable {
    let id: UUID

    var nome: String
    var limiteTotal: Double

    var finalCartao: String
    var cvv: String

    var status: StatusCartao
    var tipo: TipoCartao

    var gastos: [Gasto]

    var totalGasto: Double {
        gastos.reduce(0) { $0 + $1.valor }
    }

    var limiteDisponivel: Double {
        limiteTotal - totalGasto
    }

    var percentualUsado: Double {
        guard limiteTotal > 0 else { return 0 }
        return min(totalGasto / limiteTotal, 1.0)
    }

    var gastosMesAtual: Double {
        let calendar = Calendar.current
        let hoje = Date()
        return gastos
            .filter { calendar.isDate($0.data, equalTo: hoje, toGranularity: .month) }
            .reduce(0) { $0 + $1.valor }
    }
}
