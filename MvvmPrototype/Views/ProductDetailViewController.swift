import UIKit
import JGProgressHUD
import SideMenu

class ProductDetailViewController : BaseViewController<ProductDetailViewModel>, ProductDetailViewModelDelegate {
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    override func setupBinding() {
        super.setupBinding()
        self.viewModel.delegate = self
        
        _ = self.viewModel.product.asObservable().subscribe(onNext: { (product) in
            self.productNameLabel.text = product?.name
        })
    }
}
