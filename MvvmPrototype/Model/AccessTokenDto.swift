import Foundation

class AccessTokenDto : BaseApiResponseDto, Decodable {
    var access_token: String!
    var refresh_token: String!
    var expires_in: Int!
    
    init(accessToken: String, refreshToken: String, expiresIn: Int)
    {
        access_token = accessToken
        refresh_token = refreshToken
        expires_in = expiresIn
    }
}
