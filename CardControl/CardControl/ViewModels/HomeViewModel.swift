import Foundation
import Combine

/// Responsável pelas informações exibidas na tela inicial do aplicativo.
final class HomeViewModel: ObservableObject {

    @Published var titulo = "Meus Cartões"
}
