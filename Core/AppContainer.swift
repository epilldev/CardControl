class AppContainer {
    static let shared = AppContainer()
    
    let cardRepository = CardRepository()
    let expenseRepository = ExpenseRepository()
}
``