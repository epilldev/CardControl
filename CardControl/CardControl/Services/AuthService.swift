import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

/// Centraliza as operações de autenticação do aplicativo.
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
    func signInWithGoogle(
        completion: @escaping (Result<Usuario, Error>) -> Void
    ) {

        /// Recupera o Client ID configurado no Firebase.
        guard
            let clientID =
                FirebaseApp.app()?.options.clientID
        else {
            return
        }

        let config =
            GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration =
            config

        /// Obtém a tela atual para apresentar o login Google.
        guard
            let scene =
                UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
            let rootViewController =
                scene.windows.first?.rootViewController
        else {
            return
        }

        /// Exibe a tela de seleção de conta Google.
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        ) { result, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            /// Recupera os dados retornados pelo Google.
            guard
                let user = result?.user,
                let idToken =
                    user.idToken?.tokenString
            else {
                return
            }

            /// Cria a credencial utilizada pelo Firebase.
            let credential =
                GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )

            /// Realiza a autenticação no Firebase.
            Auth.auth().signIn(
                with: credential
            ) { authResult, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let firebaseUser =
                    authResult?.user
                else {
                    return
                }

                /// Converte o usuário do Firebase para o modelo da aplicação.
                let usuario = Usuario(
                    id: firebaseUser.uid,
                    nome: firebaseUser.displayName ?? "",
                    email: firebaseUser.email ?? "",
                    cartoes: []
                )

                completion(.success(usuario))
            }
        }
    }
}
