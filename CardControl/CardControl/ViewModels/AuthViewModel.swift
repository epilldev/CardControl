import Foundation
import Combine

final class AuthViewModel: ObservableObject {

    /// Representa o usuário autenticado atualmente.
    @Published var usuario: Usuario?

    var usuarioLogado: Bool {

        usuario != nil
    }

    init() {

        usuario =
            AuthService.shared.usuarioAtual
    }
}
