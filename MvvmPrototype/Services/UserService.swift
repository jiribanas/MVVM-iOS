import Foundation
import UIKit
import Signals

class UserService: UserServiceProtocol {

    internal var networkService: NetworkServiceProtocol
    
    var user : UserDto?
    var customerAccounts : Array<CustomerAccountDto>?
    var currentCustomerAccount : CustomerAccountDto?
    var onCustomerAccountSelected = Signal<Int64>()
    
    init()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        networkService = appDelegate.container.resolve(NetworkServiceProtocol.self)!
    }
    
    func startNewSession(accessToken: AccessTokenDto, completion: @escaping (_ errorMessage: String?)-> Void)
    {
        networkService.accessToken = accessToken
        networkService.getUser()
            {
                (result: UserDto?) in
                if result != nil
                {
                    self.user = result
                    self.networkService.getCustomerAccounts()
                        {
                            (customerAccounts: Array<CustomerAccountDto>?) in
                            if !(customerAccounts?.isEmpty)!
                            {
                                self.customerAccounts = customerAccounts
                                completion(nil)
                            }
                            else
                            {
                                completion("There are no customer accounts associated with your user record.")
                            }
                    }
                }
                else {
                    completion("Unable to retrieve user profile data")
                }
        }
    }
    
    func endSession(completion: @escaping ()-> Void) {
        networkService.accessToken = nil
        self.user = nil
        completion()
    }
    
    func setCurrentCustomerAccount(_ customerId: Int64)
    {
        if let customerAccount = self.customerAccounts?.first(where: { $0.id == customerId })
        {
            AppSettings.LastUsedCustomerAccountId = customerAccount.id
            currentCustomerAccount = customerAccount
            onCustomerAccountSelected.fire(customerId)
        }
    }
    
    func customerAccounts(_ searchString: String?) -> [CustomerAccountDto]? {
        return self.customerAccounts?.sorted(by: { (account1, account2) -> Bool in
            return account1.name.localizedCaseInsensitiveCompare(account2.name) == .orderedAscending
        })
    }
}
