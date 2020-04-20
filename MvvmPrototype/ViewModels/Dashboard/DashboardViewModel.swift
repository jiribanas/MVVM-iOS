import Foundation
import RxSwift
import RxCocoa

protocol DashboardViewModelDelegate: ViewModelDelegate {
}

class DashboardViewModel: BaseViewModel
{
    internal weak var delegate: DashboardViewModelDelegate?
    internal var productCatalogService: ProductCatalogServiceProtocol
    
    var products = BehaviorRelay<[Product]>(value: [Product]())
    
    required init(_ params: Any?)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        productCatalogService = appDelegate.container.resolve(ProductCatalogServiceProtocol.self)!
        
        super.init(params)
        
        self.loadSampleProducts()
    }
    
    func loadSampleProducts()
    {
        productCatalogService.getProducts(code: "AAA")
        {
            (result: [Product]?) in
            if result?.count ?? 0 > 0
            {
                self.products.accept(result!)
            }
        }
    }
    
    func showProductDetail(_ product: Product)
    {
        self.navigationService.showViewModel(to: ProductDetailViewModel.self, stack: .master, params: product)
    }
}
