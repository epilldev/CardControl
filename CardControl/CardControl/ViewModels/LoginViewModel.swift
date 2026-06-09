import Foundation
import Combine

/// Responsável pelo gerenciamento do estado de autenticação.
final class LoginViewModel: ObservableObject {

    /// Indica se existe um usuário autenticado.
    @Published var usuarioAutenticado = false

    init() {

        usuarioAutenticado =
            AuthService.shared.usuarioAtual != nil
    }

    /// Atualiza o estado da autenticação após o login.
    func atualizarAutenticacao() {

        usuarioAutenticado =
            AuthService.shared.usuarioAtual != nil
    }
}
