import Foundation

class NetworkService: NetworkServiceProtocol {
    
    var accessToken : AccessTokenDto?
    
    func getAccessTokenForUsernameAndPassword(username: String!, password: String!, completion: @escaping (_ result: AccessTokenDto?) -> Void)
    {
        let mockToken = AccessTokenDto(accessToken: "AAA", refreshToken: "BBB", expiresIn: 60000)
        completion(mockToken)
    }
    
    func getUser(completion: @escaping (_ result: UserDto?) -> Void)
    {
        let mockUser = UserDto(id: 1001, username: "jiri-tester", firstname: "Jiri", lastname: "Tester")
        completion(mockUser)
    }
    
    func getCustomerAccounts(completion: @escaping (_ result: Array<CustomerAccountDto>?) -> Void)
    {
        var customers = [CustomerAccountDto]()
        customers.append(CustomerAccountDto(id: 1, accountNumber: "3232", name: "Test 1"))
        customers.append(CustomerAccountDto(id: 2, accountNumber: "3r2", name: "Test 2"))
        customers.append(CustomerAccountDto(id: 3, accountNumber: "45f42", name: "Test 3"))
        completion(customers)
    }
    
    func getProducts(customerId: Int64, lastUpdated: Date? = nil, completion: @escaping (_ result: ChangeSet?) -> Void)
    {
        var newProducts = [ProductDto]()
        newProducts.append(ProductDto(id: 1, code: "AAA", name: "Product 1", brandId: 1))
        newProducts.append(ProductDto(id: 2, code: "AAA", name: "Product 2", brandId: 1))
        newProducts.append(ProductDto(id: 3, code: "AAA", name: "Product 3", brandId: 1))
        newProducts.append(ProductDto(id: 4, code: "AAA", name: "Product 4", brandId: 1))
        newProducts.append(ProductDto(id: 5, code: "AAA", name: "Product 5", brandId: 1))
        newProducts.append(ProductDto(id: 6, code: "AAA", name: "Product 6", brandId: 1))
        newProducts.append(ProductDto(id: 7, code: "AAA", name: "Product 7", brandId: 1))
        let changeset = ChangeSet(new: newProducts)
        completion(changeset)
    }
}
