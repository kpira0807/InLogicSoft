import UIKit

final class AppNavigator: NavigationNode {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
        super.init(parent: nil)
    }
    
    func startFlow() {
        let coordinator = BikesCoordinator(parent: self)
        let controller = coordinator.createFlow()
        
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
}
