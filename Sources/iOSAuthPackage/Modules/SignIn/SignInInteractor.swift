//
//  SignInInteractor.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//  
//

import Foundation

class SignInInteractor: PresenterToInteractorSignInProtocol {
    // MARK: Properties
    weak var presenter: InteractorToPresenterSignInProtocol?
        
    func validateEmail(_ email: String) {
        presenter?.fetchValidEmail(email.count > 0)
    }
    
    func validatePassword(_ pass: String) {
        presenter?.fetchValidPasswrod(pass.count > 0)
    }
    
    func signIn(email: String, password: String) {
        NetworkService.shared.signIn(stringURL: NetworkURL.loginURL, username: email, password: password) { [weak self] result in
            guard let self else {
                self?.presenter?.signInFailure(error: NetworkErrors.serverError)
                return
            }
            switch result {
            case .success(let success):
                switch success.status {
                case .OK:
                    do {
                        guard let data = success.data as? Data else { throw AuthorizationError.unknownError }
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let token = json["accessToken"] as? String {
                                self.loginUser(with: token)
                            }
                        }
                    } catch {
                        self.presenter?.signInFailure(error: error)
                    }
                default:
                    self.presenter?.signInFailure(error: AuthorizationError.unknownError)
                }
            case .failure(let error):
                self.presenter?.signInFailure(error: error)
            }
        }
    }
    
    private func loginUser(with token: String) {
        LoginService.shared.saveLoggedUser(token: token)
        self.presenter?.signInSuccess()
    }
    
}
