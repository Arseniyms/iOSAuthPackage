//
//  LoginService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 15.11.2022.
//

import Foundation

struct LoginService {
    private init() { }
    
    static var shared: LoginService { LoginService() }
    
    func saveLoggedUser(token: String) {
        UserDefaults.standard.set(token, forKey: Constants.loginService)
    }
    
    func getLoggedUser() -> String? {
        return UserDefaults.standard.string(forKey: Constants.loginService)
    }
    
    func deleteLoggedUser() {
        UserDefaults.standard.removeObject(forKey: Constants.loginService)
    }
}
