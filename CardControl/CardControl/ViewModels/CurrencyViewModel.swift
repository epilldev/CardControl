import Foundation
import Observation

enum NetworkState {
    case idle
    case loading
    case success(CurrencyInfo)
    case error(String)
}

@Observable
class CurrencyViewModel {
    var state: NetworkState = .idle
    
    func fetchExchangeRate() async {
        state = .loading

        guard let url = URL(string: "https://economia.awesomeapi.com.br/last/USD-BRL?token=51141fea1d8cd0df17fa687202c82561e683c9bea4abfd6f0e5d4efb73fb0390") else {
            state = .error("URL inválida.")
            return
        }
        
        do {
            // Faz a requisição de rede com URLSession
            let delegate = NetworkDelegate()
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            
            let (data, response) = try await session.data(from: url)
            
            // Verifica se a resposta do servidor está OK
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                state = .error("Erro no servidor.")
                return
            }
            
            // A AwesomeAPI envia o objeto dentro de uma chave (ex: "USDBRL")
            // Usamos um dicionário temporário para extrair o objeto de lá de dentro
            let json = try JSONDecoder().decode([String: CurrencyInfo].self, from: data)
            
            if let currencyData = json["USDBRL"] {
                state = .success(currencyData)
            } else {
                state = .error("Dados não encontrados.")
            }
            
        } catch {
            state = .error("Falha na rede: \(error.localizedDescription)")
        }
    }

    class NetworkDelegate: NSObject, URLSessionDelegate {
        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if let trust = challenge.protectionSpace.serverTrust {
                completionHandler(.useCredential, URLCredential(trust: trust))
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        }
    }

}

