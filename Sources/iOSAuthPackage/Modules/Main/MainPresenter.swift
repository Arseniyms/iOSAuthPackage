//
//  MainPresenter.swift
//  SetiAuth
//
//  Created by Arseniy Matus on 10.03.2023.
//  
//

import Foundation

class MainPresenter: ViewToPresenterMainProtocol {

    // MARK: Properties
    weak var view: PresenterToViewMainProtocol?
    var interactor: PresenterToInteractorMainProtocol?
    var router: PresenterToRouterMainProtocol?
    
    func viewDidLoad() {
        interactor?.getInfo()
    }
    
    func exit() {
        interactor?.deleteLoggedUser()
        router?.switchToSignIn(on: view!)
    }
}

extension MainPresenter: InteractorToPresenterMainProtocol {
    func getInfoSuccess(isAdmin: Bool, _ info: [Info]) {
        DispatchQueue.main.async {
            self.view?.setupSuccessAlert(isAdmin: isAdmin, with: info)
        }
    }
    
    func getInfoFailure(with error: Error) {
        DispatchQueue.main.async {
            self.view?.setupErrorAlert(title: "Ошибка", message: error.localizedDescription)
        }
    }
}
