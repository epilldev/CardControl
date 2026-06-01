import Foundation
import SwiftUI
import Combine

/// Responsável pelo controle central de navegação do aplicativo.
final class AppRouter: ObservableObject {

    @Published var path = NavigationPath()
}
