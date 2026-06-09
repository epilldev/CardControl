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

    /// Responsável por iniciar a autenticação Google.
    func realizarLoginGoogle() {

        AuthService.shared.signInWithGoogle { [weak self] result in

            DispatchQueue.main.async {

                switch result {

                case .success:

                    self?.usuarioAutenticado = true

                case .failure(let error):

                    print(
                        "Erro ao autenticar: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
}
