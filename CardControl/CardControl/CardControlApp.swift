//
//  CardControlApp.swift
//  CardControl
//

import SwiftUI
import CoreData

@main
struct CardControlApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
