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

    /// Responsável por remover um cartão do banco de dados local.
    func removerCartao(_ cartao: CartaoEntity) {

        context.delete(cartao)

        salvarContexto()
    }
}
