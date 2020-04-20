import Foundation

class CustomerAccountDto : BaseApiResponseDto, Decodable {
    var id: Int64!
    var accountNumber: String!
    var code: String?
    var name: String!
    
    init(id: Int64, accountNumber: String, name: String)
    {
        self.id = id
        self.accountNumber = accountNumber
        self.name = name
    }
}
