import SwiftUI
import UIKit

/// Tela responsável pelo cadastro de novos cartões.
struct CreateCardView: View {
    
    @StateObject private var viewModel =
    CreateCardViewModel()
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var mostrarErro = false
    
    var body: some View {
        
        ZStack {
            
            Color(
                red: 0.96,
                green: 0.94,
                blue: 1.00
            )
            .ignoresSafeArea()
            
            Form {
                
                cabecalho
                
                previewCartao
                
                dadosCartao
                
                botaoSalvar
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Novo Cartão")
        .navigationBarTitleDisplayMode(.inline)
        
        /// Exibe erros de validação.
        .alert(
            "Não foi possível criar o cartão",
            isPresented: $mostrarErro
        ) {
            
            Button("OK") { }
            
        } message: {
            
            Text(viewModel.mensagemErro)
        }
    }
    
    // MARK: - Cabeçalho
    
    private var cabecalho: some View {
        Section {
            
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                
                Text("Novo Cartão")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(
                    "Cadastre um novo cartão para controlar seus gastos."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }
    // MARK: - Preview do cartão
    
    private var previewCartao: some View {
        
        Section("Pré-visualização") {
            
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color(
                            red: 0.42,
                            green: 0.17,
                            blue: 0.88
                        ),
                        Color(
                            red: 0.10,
                            green: 0.03,
                            blue: 0.35
                        )
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {
                    
                    HStack {
                        
                        Text(
                            viewModel.nome.isEmpty
                            ? "Nome do Cartão"
                            : viewModel.nome
                        )
                        .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(
                            viewModel.cartaoVirtual
                            ? "Virtual"
                            : "Físico"
                        )
                        .font(.caption)
                    }
                    
                    Spacer()
                    
                    Text(
                        "•••• •••• •••• \(viewModel.finalCartao.isEmpty ? "0000" : viewModel.finalCartao)"
                    )
                    .font(
                        .system(
                            .body,
                            design: .monospaced
                        )
                    )
                }
                .foregroundColor(.white)
                .padding()
            }
            .frame(height: 140)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20
                )
            )
        }
    }
    
    // MARK: - Dados do Cartão
    
    private var dadosCartao: some View {
        
        Section("Dados do Cartão") {
            
            HStack {
                
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.purple)
                
                TextField(
                    "Ex: Nubank Platinum",
                    text: $viewModel.nome
                )
            }
            
            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                
                HStack {
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    
                    TextField(
                        "Ex: 5000",
                        text: $viewModel.limiteTotal
                    )
                }
                .keyboardType(.decimalPad)
                .onChange(
                    of: viewModel.limiteTotal
                ) { _, novoValor in
                    
                    let filtrado =
                    novoValor.filter {
                        
                        $0.isNumber ||
                        $0 == "," ||
                        $0 == "."
                    }
                    
                    viewModel.limiteTotal =
                    filtrado
                }
                
                if let valor = valorFormatado {
                    
                    Text(
                        "Limite informado: \(valor)"
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            HStack {
                
                Image(systemName: "number.square.fill")
                    .foregroundColor(.orange)
                
                TextField(
                    "Últimos 4 dígitos",
                    text: $viewModel.finalCartao
                )
            }
            .keyboardType(.numberPad)
            .onChange(
                of: viewModel.finalCartao
            ) { _, novoValor in
                
                viewModel.finalCartao =
                String(
                    novoValor
                        .filter(\.isNumber)
                        .prefix(4)
                )
            }
            
            HStack {
                
                Image(systemName: "lock.fill")
                    .foregroundColor(.red)
                
                TextField(
                    "CVV (3 dígitos)",
                    text: $viewModel.cvv
                )
            }
            .keyboardType(.numberPad)
            .onChange(
                of: viewModel.cvv
            ) { _, novoValor in
                
                viewModel.cvv =
                String(
                    novoValor
                        .filter(\.isNumber)
                        .prefix(3)
                )
            }
            
            Toggle(
                "Cartão Virtual",
                isOn: $viewModel.cartaoVirtual
            )
            .tint(
                Color(
                    red: 0.42,
                    green: 0.17,
                    blue: 0.88
                )
            )
            
            HStack(spacing: 6) {
                
                Image(
                    systemName: viewModel.cartaoVirtual
                    ? "iphone"
                    : "creditcard.fill"
                )
                .foregroundColor(
                    viewModel.cartaoVirtual
                    ? .blue
                    : .purple
                )
                
                Text(
                    viewModel.cartaoVirtual
                    ? "Cartão Virtual"
                    : "Cartão Físico"
                )
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Botão Salvar
    
    private var botaoSalvar: some View {
        
        Section {
            
            Button {
                
                if viewModel.validarDados() {
                    
                    viewModel.salvarCartao()
                    
                    UINotificationFeedbackGenerator()
                        .notificationOccurred(.success)
                    
                    dismiss()
                    
                } else {
                    
                    UINotificationFeedbackGenerator()
                        .notificationOccurred(.error)
                    
                    mostrarErro = true
                }
                
            } label: {
                
                Text("Salvar Cartão")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(
                .borderedProminent
            )
            .tint(
                Color(
                    red: 0.42,
                    green: 0.17,
                    blue: 0.88
                )
            )
            .disabled(!podeSalvar)
            .opacity(
                podeSalvar ? 1 : 0.6
            )
        }
    }
    
    // MARK: - Valor formatado
    
    private var valorFormatado: String? {
        
        let texto =
        viewModel.limiteTotal
            .replacingOccurrences(
                of: ",",
                with: "."
            )
        
        guard let valor =
                Double(texto)
        else {
            return nil
        }
        
        let formatter =
        NumberFormatter()
        
        formatter.numberStyle =
            .currency
        
        formatter.locale =
        Locale(
            identifier: "pt_BR"
        )
        
        return formatter.string(
            from: NSNumber(
                value: valor
            )
        )
    }
    
    /// Responsável por verificar se todos os campos foram preenchidos.
    private var podeSalvar: Bool {
        
        !viewModel.nome
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
        &&
        !viewModel.limiteTotal.isEmpty
        &&
        viewModel.finalCartao.count == 4
        &&
        viewModel.cvv.count == 3
    }}

#Preview {
    
    NavigationStack {
        
        CreateCardView()
    }
}
