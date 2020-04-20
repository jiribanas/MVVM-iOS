import Foundation
import RxSwift
import RxCocoa

protocol ProductDetailViewModelDelegate: ViewModelDelegate {
}

class ProductDetailViewModel: BaseViewModel
{
    internal weak var delegate: ProductDetailViewModelDelegate?
    
    var product = BehaviorRelay<Product?>(value: nil)
    
    required init(_ params: Any?) {
        super.init(params)
        
        if (params != nil && params is Product)
        {
            product.accept(params as? Product)
        }
    }
}
