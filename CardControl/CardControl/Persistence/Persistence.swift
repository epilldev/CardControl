//
//  Persistence.swift
//  CardControl
//

import CoreData

/// Responsável pela configuração do Core Data da aplicação.
struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {

        container = NSPersistentContainer(name: "CardControl")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in

            if let error = error as NSError? {
                fatalError(
                    """
                    Erro ao carregar o Core Data:
                    \(error),
                    \(error.userInfo)
                    """
                )
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
