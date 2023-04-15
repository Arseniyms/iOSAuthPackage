//
//  LoginService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 15.11.2022.
//

import Foundation

public struct LoginService {
    private init() { }
    
    public static var shared: LoginService { LoginService() }
    
    public func saveLoggedUser(token: String) {
        UserDefaults.standard.set(token, forKey: Constants.loginService)
    }
    
    public func getLoggedUser() -> String? {
        return UserDefaults.standard.string(forKey: Constants.loginService)
    }
    
    public func deleteLoggedUser() {
        UserDefaults.standard.removeObject(forKey: Constants.loginService)
    }
}
