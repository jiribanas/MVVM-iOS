import UIKit
import SideMenu

class SideMenuViewController : BaseViewController<SideMenuViewModel>, SideMenuViewModelDelegate  {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func setupBinding() {
        super.setupBinding()
        self.viewModel.delegate = self
        
        logoutButton.rx.tap.bind{self.viewModel.logout()}.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.usernameLabel.text = "\(self.viewModel.userService.user?.firstName ?? "") \(self.viewModel.userService.user?.lastName ?? "")".uppercased()
    }
}
