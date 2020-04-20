import Foundation
import UIKit
import SideMenu

class NavigationService: NavigationServiceProtocol
{
    func showViewModel(from sourceViewModel: BaseViewModel, to destinationViewModel: BaseViewModel.Type, stack: NavigationStack = .master, params: Any?)
    {
        let viewController = self.getViewControllerForViewModel(viewModel: destinationViewModel, params: params)
        
        switch stack
        {
            case .master:
                if let topNavigationController = UIApplication.getTopMostViewController()?.navigationController {
                    viewController.transitioningDelegate = sourceViewModel.baseDelegate as? UIViewControllerTransitioningDelegate
                    topNavigationController.pushViewController(viewController, animated: true)
                }
            case .modal:
                if let topNavigationController = UIApplication.getTopMostViewController()?.navigationController {
                    let navBarOnModal = getModalNavigationController(viewController)
                    navBarOnModal.transitioningDelegate = sourceViewModel.baseDelegate as? UIViewControllerTransitioningDelegate
                    topNavigationController.present(navBarOnModal, animated: true, completion: nil)
            }
        }
    }
    
    func showViewModel(to destinationViewModel: BaseViewModel.Type, stack: NavigationStack, params: Any?)
    {
        let viewController = self.getViewControllerForViewModel(viewModel: destinationViewModel, params: params)
        
        switch stack {
        case .master:
            if let topNavigationController = UIApplication.getTopMostViewController()?.navigationController {
                topNavigationController.pushViewController(viewController, animated: true)
            }
        case .modal:
            if let topNavigationController = UIApplication.getTopMostViewController()?.navigationController {
                let navBarOnModal = getModalNavigationController(viewController)
                topNavigationController.present(navBarOnModal, animated: true, completion: nil)
            }
        }
    }
    
    func getViewControllerForViewModel(viewModel: BaseViewModel.Type, params: Any?) -> UIViewController
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let controller = appDelegate.viewModelMap[String(describing: viewModel.self)]
        let identifier = String(reflecting: controller!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! BaseViewControllerProtocol
        viewController.processParams(params)
        return viewController as! UIViewController
    }
    
    func presentDashboard()
    {
        if let topController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            topController.setNavigationBarHidden(false, animated: false)
            let dashboardController = topController.storyboard?.instantiateViewController(withIdentifier: "MvvmPrototype.DashboardViewController")
            topController.setViewControllers([dashboardController!], animated:true)
            
            let sideMenuViewController = topController.storyboard!.instantiateViewController(withIdentifier: "MvvmPrototype.SideMenuViewController") as! SideMenuViewController
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuViewController)
            SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
            
            SideMenuManager.default.menuAddPanGestureToPresent(toView: topController.navigationBar)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: topController.view)
            SideMenuManager.default.menuFadeStatusBar = false
            
            SideMenuManager.default.menuWidth = CGFloat(UIScreen.main.bounds.width * 0.85)
            SideMenuManager.default.menuPresentMode = SideMenuManager.MenuPresentMode.viewSlideInOut
        }
    }
    
    func presentLogin()
    {
        if let topController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            topController.setNavigationBarHidden(false, animated: false)
            let dashboardController = topController.storyboard?.instantiateViewController(withIdentifier: "MvvmPrototype.LoginViewController") as! UIViewController
            topController.setViewControllers([dashboardController], animated:true)
            
            hideSideMenu()
        }
    }
    
    @objc func showSideMenu(){
        if let topController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            topController.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
    }
    
    func hideSideMenu() {
        if SideMenuManager.defaultManager.menuLeftNavigationController?.isHidden == false {
            SideMenuManager.defaultManager.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func getModalNavigationController(_ viewController: UIViewController) -> UINavigationController {
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: viewController )
        return navBarOnModal
    }
}
