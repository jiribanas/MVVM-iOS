import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelDelegate: ViewModelDelegate {
}

class LoginViewModel: BaseViewModel
{
    internal weak var delegate: LoginViewModelDelegate?
    internal var networkService: NetworkServiceProtocol
    internal var productCatalogService: ProductCatalogServiceProtocol
    
    var username = BehaviorRelay<String>(value: "default")
    var password = BehaviorRelay<String>(value: "no-password:)")
    
    required init(_ params: Any?)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        networkService = appDelegate.container.resolve(NetworkServiceProtocol.self)!
        productCatalogService = appDelegate.container.resolve(ProductCatalogServiceProtocol.self)!
        
        super.init(params)
        
        self.productCatalogService.onCatalogLoadingFinished.subscribeOnce(with: self) { (_, wasSuccess: Bool, errorMessage: String?) in
            DispatchQueue.main.async
                {
                    super.isBusy.accept(false)
                    if wasSuccess
                    {
                        self.navigationService.presentDashboard()
                    }
                    else
                    {
                        self.delegate?.showAlert(title: "Unable to load product catalog", message: errorMessage ?? "Please try again")
                    }
            }
        }
    }
    
    func login()
    {
        self.delegate?.setHudText("Please wait...")
        super.isBusy.accept(true)
        
        self.networkService.getAccessTokenForUsernameAndPassword(username: username.value, password: password.value) {
            (result: AccessTokenDto?) in
            if result?.access_token != nil
            {
                self.userService.startNewSession(accessToken: result!) {
                    (errorMessage: String?) in
                    if (errorMessage == nil)
                    {
                        let defaultCustomerAccountId = AppSettings.LastUsedCustomerAccountId
                        if (defaultCustomerAccountId == nil)
                        {
                            self.delegate?.setHudText("Loading catalog...")
                            self.userService.setCurrentCustomerAccount(self.userService.customerAccounts(nil)!.first!.id)
                        }
                        else
                        {
                            self.delegate?.setHudText("Updating catalog...")
                            self.userService.setCurrentCustomerAccount(defaultCustomerAccountId!)
                        }
                    }
                    else
                    {
                        super.isBusy.accept(false)
                        self.delegate?.showAlert(title: "Cannot Login", message: errorMessage!)
                    }
                }
            }
            else
            {
                super.isBusy.accept(false)
                self.delegate?.showAlert(title: "Cannot Login", message: "The user name or password is incorrect. Try again.")
            }
        }
    }
}
