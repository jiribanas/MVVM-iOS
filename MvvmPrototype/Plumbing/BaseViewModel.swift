import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: Hashable, BaseViewModelProtocol
{
    var userService: UserServiceProtocol
    var navigationService: NavigationServiceProtocol
    var baseDelegate: Any?
    var isBusy = BehaviorRelay<Bool>(value: false)
    
    required init(_ params: Any?)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        userService = appDelegate.container.resolve(UserServiceProtocol.self)!
        navigationService = appDelegate.container.resolve(NavigationServiceProtocol.self)!
    }
    
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.hashValue)
    }
}

protocol BaseViewModelProtocol {
    init(_ params: Any?)
}
