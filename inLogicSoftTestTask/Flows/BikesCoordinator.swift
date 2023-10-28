import UIKit
import Swinject

final class BikesCoordinator: NavigationNode {
    
    var navigationController: UINavigationController? {
        rootViewController.navigationController
    }
    private weak var rootViewController: UIViewController!
    private weak var viewController: UIViewController?
    private var container: Container!
    
    override init(parent: NavigationNode?) {
        super.init(parent: parent)
        
        registerFlow()
        addHandlers()
    }
    
    private func registerFlow() {
        container = Container()
        
        BikesAssembly(self).assemble(container: container)
    }
    
    private func addHandlers() {
        // add Settings flow event handlers
    }
    
}

extension BikesCoordinator: Coordinator {
    
    func createFlow() -> UIViewController {
        let controller: BikesViewController = container.autoresolve(argument: self as BikesNavigationHandler)
        rootViewController = controller
        
        return controller
    }
    
}

extension BikesCoordinator: BikesNavigationHandler {}
