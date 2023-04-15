//
//  MainRouter.swift
//  SetiAuth
//
//  Created by Arseniy Matus on 10.03.2023.
//  
//

import Foundation
import UIKit

class MainRouter: PresenterToRouterMainProtocol {
    // MARK: Static methods
    static func createModule() -> UIViewController {
        
        let viewController = MainViewController()
        
        let presenter: ViewToPresenterMainProtocol & InteractorToPresenterMainProtocol = MainPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = MainRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = MainInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
    func switchToSignIn(on view: PresenterToViewMainProtocol) {
        let signInViewController = SignInRouter.createModule()
        
        guard let vc = view as? MainViewController, let window = vc.view.window else {
            return
        }
        
        window.switchRootViewController(signInViewController)
    }
    
}
