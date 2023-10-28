import UIKit

public protocol Coordinator {

    @discardableResult
    func createFlow() -> UIViewController

}
