import UIKit
import Nuke

class ProductCell : UITableViewCell
{
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var packSizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setProduct(product: Product!)
    {
        if product.imageUrl?.isEmpty == false
        {
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "productImagePlaceholder"),
                failureImage: UIImage(named: "productImagePlaceholder")
            )
            Nuke.loadImage(with: URL(string: product!.imageUrl!)!, options: options, into: productImage!)
        }
        
        brandNameLabel.text = String(product.id)
        productNameLabel.text = product.name
        packSizeLabel.text = "Large box of 16"
        priceLabel.text = "$19.99"
    }
}
