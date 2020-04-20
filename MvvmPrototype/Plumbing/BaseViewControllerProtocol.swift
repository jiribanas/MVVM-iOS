import Foundation
import UIKit
import SideMenu

protocol BaseViewControllerProtocol
{
    func processParams(_ params: Any?)
    func setupBinding()
    func setHudText(_ text: String)
    func showAlert(title: String, message: String)
    func showHamburgerMenu()
}
