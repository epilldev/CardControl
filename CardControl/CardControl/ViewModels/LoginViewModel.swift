import Foundation
import Combine

/// Responsável pelas regras de autenticação da tela de login.
final class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var senha = ""

    @Published var usuarioAutenticado = false

    func realizarLogin() {

        if !email.isEmpty && !senha.isEmpty {
            usuarioAutenticado = true
        }
    }
}
