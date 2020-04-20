import Foundation

protocol ViewModelDelegate: class {
    func setHudText(_ text: String)
    func showAlert(title: String, message: String)
    func dismissScreen()
    func dismissScreenWithCompletion(completion: (()->(Void))?)
}
