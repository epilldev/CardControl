//
//  CoreDataManager.swift
//  CardControl
//

import Foundation
import CoreData

/// Centraliza as operações de persistência utilizando Core Data.
final class CoreDataManager {

    static let shared = CoreDataManager()

    private let context = PersistenceController.shared.container.viewContext

    private init() { }

    /// Responsável por salvar alterações pendentes no banco de dados local.
    func salvarContexto() {
        do {
            try context.save()
        } catch {
            print("Erro ao salvar contexto: \(error)")
        }
    }

    // MARK: - Cartões

    /// Responsável por recuperar todos os cartões cadastrados no banco de dados local.
    func buscarCartoes() -> [CartaoEntity] {

        let request: NSFetchRequest<CartaoEntity> =
            CartaoEntity.fetchRequest()

        do {
            return try context.fetch(request)
        } catch {
            print("Erro ao buscar cartões: \(error)")
            return []
        }
    }

    /// Responsável por buscar um cartão a partir do seu identificador.
    func buscarCartao(id: UUID) -> CartaoEntity? {

        let request: NSFetchRequest<CartaoEntity> =
            CartaoEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        do {
            return try context.fetch(request).first
        } catch {
            print("Erro ao buscar cartão: \(error)")
            return nil
        }
    }

    /// Responsável por cadastrar um novo cartão no banco de dados local.
    func salvarCartao(
        nome: String,
        limiteTotal: Double,
        finalCartao: String,
        cvv: String,
        status: String,
        tipo: String
    ) {

        let cartao = CartaoEntity(context: context)

        cartao.id = UUID()
        cartao.nome = nome
        cartao.limiteTotal = limiteTotal
        cartao.finalCartao = finalCartao
        cartao.cvv = cvv
        cartao.status = status
        cartao.tipo = tipo

        salvarContexto()
    }

    /// Responsável por atualizar os dados de um cartão existente.
    func atualizarCartao(
        id: UUID,
        limiteTotal: Double,
        status: String
    ) {

        let request: NSFetchRequest<CartaoEntity> =
            CartaoEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        do {

            if let cartao = try context.fetch(request).first {

                print("Cartão encontrado: \(cartao.nome ?? "")")
                print("Novo limite: \(limiteTotal)")
                print("Novo status: \(status)")

                cartao.limiteTotal = limiteTotal
                cartao.status = status

                salvarContexto()

                print("Cartão atualizado com sucesso")
            }

        } catch {
            print("Erro ao atualizar cartão: \(error)")
        }
    }

    /// Responsável por remover um cartão a partir do seu identificador.
    func removerCartao(id: UUID) {

        let request: NSFetchRequest<CartaoEntity> =
            CartaoEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        do {

            if let cartao = try context.fetch(request).first {

                context.delete(cartao)

                salvarContexto()
            }

        } catch {
            print("Erro ao remover cartão: \(error)")
        }
    }

    // MARK: - Gastos

    /// Responsável por cadastrar um novo gasto vinculado a um cartão.
    func salvarGasto(
        valor: Double,
        data: Date,
        descricao: String,
        estabelecimento: String,
        categoria: String,
        cartaoId: UUID
    ) {

        guard let cartao = buscarCartao(id: cartaoId)
        else {
            print("Cartão não encontrado")
            return
        }

        let gasto = GastoEntity(context: context)

        gasto.id = UUID()
        gasto.valor = valor
        gasto.data = data
        gasto.descricao = descricao
        gasto.estabelecimento = estabelecimento
        gasto.categoria = categoria

        gasto.cartao = cartao

        salvarContexto()
    }

    /// Responsável por recuperar todos os gastos de um cartão.
    func buscarGastos(
        cartaoId: UUID
    ) -> [GastoEntity] {

        guard let cartao = buscarCartao(id: cartaoId)
        else {
            return []
        }

        let gastos =
            cartao.gastos?.allObjects
            as? [GastoEntity]
            ?? []

        return gastos.sorted {
            ($0.data ?? .now) >
            ($1.data ?? .now)
        }
    }

    /// Responsável por remover um gasto.
    func removerGasto(
        id: UUID
    ) {

        let request: NSFetchRequest<GastoEntity> =
            GastoEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        do {

            if let gasto =
                try context.fetch(request).first {

                context.delete(gasto)

                salvarContexto()
            }

        } catch {

            print("Erro ao remover gasto: \(error)")
        }
    }
}
