import Foundation
import UIKit
import RxSwift
import JGProgressHUD
import SideMenu

typealias CompletionHandler = (() -> Void)
class BaseViewController<T: BaseViewModel> : UIViewController, BaseViewControllerProtocol
{
    let disposeBag = DisposeBag()
    let hud = JGProgressHUD(style: .dark)
    
    var viewModel : T! {
        didSet {
            self.notify()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewModel = T.init(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
    }
    
    func setupBinding() {
        _ = self.viewModel.isBusy.asObservable().subscribe(onNext: { (isBusy) in
            if isBusy
            {
                self.hud.textLabel.text = "Please wait..."
                self.hud.show(in: self.view)
            }
            else
            {
                self.hud.dismiss()
            }
        })
    }
    
    func processParams(_ params: Any?)
    {
        self.viewModel = T.init(params)
    }
    
    func setHudText(_ text: String)
    {
        self.hud.textLabel.text = text
    }
    
    func showAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func dismissScreen()
    {
        self.dismiss(animated: true)
    }
    
    @objc func dismissScreenWithCompletion(completion: (()->(Void))?)
    {
        self.dismiss(animated: true, completion: completion)
    }

    private var observers = [String: CompletionHandler]()
    
    private func notify() {
        observers.forEach({ $0.value() })
    }

    deinit {
        observers.removeAll()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    @objc func showHamburgerMenu()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
