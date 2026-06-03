import SwiftUI

/// Componente responsável pela exibição visual de um cartão.
struct CardView: View {

    let cartao: Cartao

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Image(systemName: "creditcard.fill")

                Text(cartao.nome)
                    .font(.headline)

                Spacer()
            }

            Text("Final: \(cartao.finalCartao)")
                .font(.subheadline)

            Divider()

            Text("Limite Total: R$ \(cartao.limiteTotal, specifier: "%.2f")")

            Text("Limite Disponível: R$ \(cartao.limiteDisponivel, specifier: "%.2f")")

            HStack {
                Text("Status:")

                Text(cartao.status.rawValue.capitalized)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    CardView(
        cartao: Cartao(
            id: UUID(),
            nome: "Cartão Principal",
            limiteTotal: 5000,
            finalCartao: "1234",
            cvv: "123",
            status: .ativo,
            tipo: .fisico,
            gastos: []
        )
    )
}
