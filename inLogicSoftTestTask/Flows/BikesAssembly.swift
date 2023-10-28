import Swinject
import UIKit

final class BikesAssembly: Assembly {
    
    private let parent: NavigationNode
    
    init(_ parent: NavigationNode) {
        self.parent = parent
    }
    
    func assemble(container: Container) {
        container.register(BikesViewController.self) { (resolver, navigationHandler: BikesNavigationHandler) in
            let model = BikesModel(navigationHandler: navigationHandler)
            let viewModel = BikesViewModel(model: model)
            let controller = BikesViewController(viewModel: viewModel)
            
            return controller
        }.inObjectScope(.transient)
    }
    
}
