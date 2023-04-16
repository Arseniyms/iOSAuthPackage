//
//  SignInContract.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import UIKit


// MARK: View Output (Presenter -> View)
public protocol PresenterToViewSignInProtocol: AnyObject {
    func updateEmailValidation(isEmailValid: Bool)
    func updatePasswordValidation(isPassValid: Bool)
    
    func signInFailed()
}


// MARK: View Input (View -> Presenter)
public protocol ViewToPresenterSignInProtocol: AnyObject {
    
    var view: PresenterToViewSignInProtocol? { get set }
    var interactor: PresenterToInteractorSignInProtocol? { get set }
    var router: PresenterToRouterSignInProtocol? { get set }
    
    func emailDidChange(to email: String)
    func passDidChange(to password: String)
    
    func signInTapped(email: String, password: String)
    
    func goToSignUp()
}


// MARK: Interactor Input (Presenter -> Interactor)
public protocol PresenterToInteractorSignInProtocol: AnyObject {
    
    var presenter: InteractorToPresenterSignInProtocol? { get set }
    
    func validateEmail(_ email: String)
    func validatePassword(_ pass: String)
    
    func signIn(email: String, password: String)
}


// MARK: Interactor Output (Interactor -> Presenter)
public protocol InteractorToPresenterSignInProtocol: AnyObject {
    func fetchValidEmail(_ bool: Bool)
    func fetchValidPasswrod(_ bool: Bool)
    
    func signInSuccess()
    func signInFailure(error: Error)
}


// MARK: Router Input (Presenter -> Router)
public protocol PresenterToRouterSignInProtocol: AnyObject {
    
    var pushToMainControllerAction: ((PresenterToViewSignInProtocol) -> Void)? { get set }
    func pushToSignUpController(on view: PresenterToViewSignInProtocol)
    func pushToMainController(on view: PresenterToViewSignInProtocol)
    
    func showErrorAlert(on view: PresenterToViewSignInProtocol, title: String, message: String, handler: ((UIAlertAction) -> Void)?)
}
