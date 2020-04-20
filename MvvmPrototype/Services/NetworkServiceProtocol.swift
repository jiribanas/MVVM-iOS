import Foundation

protocol NetworkServiceProtocol: class
{
    var accessToken : AccessTokenDto? { get set }
    
    func getAccessTokenForUsernameAndPassword(username: String!, password: String!, completion: @escaping (_ result: AccessTokenDto?) -> Void)
    func getUser(completion: @escaping (_ result: UserDto?) -> Void)
    func getCustomerAccounts(completion: @escaping (_ result: Array<CustomerAccountDto>?) -> Void)
    func getProducts(customerId: Int64, lastUpdated: Date?, completion: @escaping (_ result: ChangeSet?) -> Void)
}
