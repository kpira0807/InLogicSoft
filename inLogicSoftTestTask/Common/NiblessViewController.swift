import Foundation
import UIKit

open class NiblessViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Init is not implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
