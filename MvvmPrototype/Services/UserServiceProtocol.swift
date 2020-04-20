import Foundation
import Signals

protocol UserServiceProtocol: class
{
    // Signals
    var onCustomerAccountSelected : Signal<Int64> { get }
    
    // Properties
    var user : UserDto? { get }
    var currentCustomerAccount : CustomerAccountDto? { get }
    
    // Methods
    func startNewSession(accessToken: AccessTokenDto, completion: @escaping (_ errorMessage: String?)-> Void)
    func endSession(completion: @escaping ()-> Void)
    
    func customerAccounts(_ searchString: String?) -> [CustomerAccountDto]?
    func setCurrentCustomerAccount(_ customerId: Int64)
}

