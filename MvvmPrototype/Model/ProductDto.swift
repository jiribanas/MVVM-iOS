import Foundation

class ProductDto : Codable {
    let id: Int64
    let code, name: String
    let longDescription: String?
    let imageUrl: String?
    let brandId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, code, name, longDescription, imageUrl, brandId
    }
    
    init(id: Int64, code: String, name: String, brandId: Int)
    {
        self.id = id
        self.code = code
        self.name = name
        self.brandId = brandId
        self.longDescription = nil
        self.imageUrl = "https://cdn.mygreenfills.com/images/product-images/Trial_Wash.png"
    }
}

class ChangeSet: BaseApiResponseDto, Codable
{
    let new, updated: [ProductDto]?
    let removed: [Int64]?
    
    init(new: [ProductDto])
    {
        self.new = new
        self.updated = nil
        self.removed = nil
    }
}

