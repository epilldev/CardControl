//
//  CardControlApp.swift
//  CardControl
//

import SwiftUI
import CoreData
import FirebaseCore

@main
struct CardControlApp: App {

    let persistenceController =
        PersistenceController.shared

    init() {

        /// Inicializa os serviços do Firebase ao abrir o aplicativo.
        FirebaseApp.configure()
    }

    var body: some Scene {

        WindowGroup {

            SplashView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
        }
    }
}
