import Foundation
import Signals

protocol ProductCatalogServiceProtocol: class
{
    var onCatalogLoadingFinished : Signal<(customerAccountId: Int64, wasSuccesful: Bool, error: String?)> { get set }
    func loadCatalogAsync()
    
    func getProducts(code: String!, completion: @escaping (_ results: [Product]?)-> Void)
    func getProduct(dssId: Int64) -> Product?
}
