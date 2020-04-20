import UIKit
import JGProgressHUD
import SideMenu

class DashboardViewController : BaseViewController<DashboardViewModel>, DashboardViewModelDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    override func setupBinding() {
        super.setupBinding()
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        tableView.tableFooterView = UIView()
        
        let hamburgerMenuButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        hamburgerMenuButton.setImage(UIImage(named: "ic_menu"), for: UIControl.State.normal)
        hamburgerMenuButton.addTarget(self, action: #selector(super.showHamburgerMenu), for: UIControl.Event.touchUpInside)
        hamburgerMenuButton.frame = CGRect(x:0, y:0, width:53, height:50)
        hamburgerMenuButton.accessibilityIdentifier = "hamburgerMenu"
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: hamburgerMenuButton)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension DashboardViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedItem = self.viewModel.products.value[indexPath.row]
        self.viewModel.showProductDetail(selectedItem)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.setProduct(product: self.viewModel.products.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
}

extension DashboardViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.products.value.count
    }
}
