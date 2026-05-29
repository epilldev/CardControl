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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
