import Foundation
import UIKit

enum NavigationStack {
    case master
    case modal
}

protocol NavigationServiceProtocol: class
{
    func presentDashboard()
    func presentLogin()
    func showViewModel(from sourceViewModel: BaseViewModel, to destinationViewModel: BaseViewModel.Type, stack: NavigationStack, params: Any?)
    func showViewModel(to destinationViewModel: BaseViewModel.Type, stack: NavigationStack, params: Any?)
    func getViewControllerForViewModel(viewModel: BaseViewModel.Type, params: Any?) -> UIViewController
}
