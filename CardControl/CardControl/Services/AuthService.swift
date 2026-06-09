import Foundation
import FirebaseAuth

/// Responsável pelas operações de autenticação da aplicação.
final class AuthService {

    static let shared = AuthService()

    private init() { }

    /// Retorna o usuário autenticado atualmente.
    var usuarioAtual: Usuario? {

        guard let user = Auth.auth().currentUser else {
            return nil
        }

        return Usuario(
            id: user.uid,
            nome: user.displayName ?? "",
            email: user.email ?? "",
            cartoes: []
        )
    }

    /// Responsável por autenticar o usuário com sua conta Google.
    func signInWithGoogle() {

    }
}
