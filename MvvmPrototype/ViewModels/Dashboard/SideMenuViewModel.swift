import Foundation
import RxSwift
import RxCocoa

protocol SideMenuViewModelDelegate: ViewModelDelegate {
}

class SideMenuViewModel: BaseViewModel
{
    internal weak var delegate: SideMenuViewModelDelegate?
    
    func logout() {
        self.userService.endSession()
        {
            self.navigationService.presentLogin()
        }
    }
}
