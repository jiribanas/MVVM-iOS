import UIKit
import JGProgressHUD
import SideMenu

class LoginViewController : BaseViewController<LoginViewModel>, LoginViewModelDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func setupBinding() {
        super.setupBinding()
        self.viewModel.delegate = self
        
        usernameTextField.rx.text.subscribe(onNext:{ text in self.viewModel.username.accept(text ?? "") }).disposed(by: disposeBag)
        _ = self.viewModel.username.asObservable().subscribe(onNext: { (username) in self.usernameTextField.text = username })
        
        passwordTextField.rx.text.subscribe(onNext:{ text in self.viewModel.password.accept(text ?? "") }).disposed(by: disposeBag)
        _ = self.viewModel.password.asObservable().subscribe(onNext: { (password) in self.passwordTextField.text = password })
        
        loginButton.rx.tap.bind{self.viewModel.login()}.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
