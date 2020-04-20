import Foundation

class UserDto : BaseApiResponseDto, Decodable {
    var id: Int64!
    var userName: String!
    var eMail: String?
    var firstName: String?
    var lastName: String?
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var zip: String?
    
    init(id: Int64, username: String, firstname: String, lastname: String)
    {
        self.id = id
        self.userName = username
        self.firstName = firstname
        self.lastName = lastname
    }
}
