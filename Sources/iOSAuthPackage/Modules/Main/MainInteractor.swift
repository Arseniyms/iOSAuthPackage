//
//  MainInteractor.swift
//  SetiAuth
//
//  Created by Arseniy Matus on 10.03.2023.
//  
//

import Foundation

class MainInteractor: PresenterToInteractorMainProtocol {

    // MARK: Properties
    weak var presenter: InteractorToPresenterMainProtocol?
    
    // MARK: Functions
    
    func getInfo() {
        guard let token = LoginService.shared.getLoggedUser() else {
            presenter?.getInfoFailure(with: AuthorizationError.idError)
            return
        }
        NetworkService.shared.getInfo(of: token) { result in
            switch result {
            case .success(let success):
                guard let data = success.data as? Data else {
                    self.presenter?.getInfoFailure(with: AuthorizationError.idError)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let infoArray = try decoder.decode([Info].self, from: data)
                    self.presenter?.getInfoSuccess(isAdmin: infoArray.count > 1, infoArray)
                } catch {
                    self.presenter?.getInfoFailure(with: error)
                    return
                }
            case .failure(let error):
                self.presenter?.getInfoFailure(with: error)
            }
        }
        
    }
    
    func deleteLoggedUser() {
        LoginService.shared.deleteLoggedUser()
    }
}
