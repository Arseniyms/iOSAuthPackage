//
//  MainContract.swift
//  SetiAuth
//
//  Created by Arseniy Matus on 10.03.2023.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
public protocol PresenterToViewMainProtocol: AnyObject {
    func setupSuccessAlert(isAdmin: Bool, with info: [Info])
    func setupErrorAlert(title: String, message: String)
}


// MARK: View Input (View -> Presenter)
public protocol ViewToPresenterMainProtocol: AnyObject {
    
    var view: PresenterToViewMainProtocol? { get set }
    var interactor: PresenterToInteractorMainProtocol? { get set }
    var router: PresenterToRouterMainProtocol? { get set }
    
    func viewDidLoad()
    func exit()
}


// MARK: Interactor Input (Presenter -> Interactor)
public protocol PresenterToInteractorMainProtocol: AnyObject {
    
    var presenter: InteractorToPresenterMainProtocol? { get set }
    
    func getInfo()
    func deleteLoggedUser()
}


// MARK: Interactor Output (Interactor -> Presenter)
public protocol InteractorToPresenterMainProtocol: AnyObject {
    func getInfoSuccess(isAdmin: Bool, _ info: [Info])
    func getInfoFailure(with error: Error)
}


// MARK: Router Input (Presenter -> Router)
public protocol PresenterToRouterMainProtocol: AnyObject {
    func switchToSignIn(on view: PresenterToViewMainProtocol)
}
