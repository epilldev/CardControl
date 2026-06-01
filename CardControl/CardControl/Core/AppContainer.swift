import Foundation

/// Responsável por centralizar as dependências compartilhadas do aplicativo.
///
final class AppContainer {

    static let shared = AppContainer()

    private init() { }

    /*
     Centralizacao de Repositories, Services, API Clients, Gerenciadores globais:
     
     let cardRepository = CardRepository()
     let expenseRepository = ExpenseRepository()
    */
}
