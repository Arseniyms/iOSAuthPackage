//
//  Errors.swift
//  EventPasser
//
//  Created by Arseniy Matus on 14.11.2022.
//

import Foundation

enum AuthorizationError: Error {
    case emailAlreadyExist, saveError, invalidEmailOrPassword, idError, unknownError, blankField
}

extension AuthorizationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emailAlreadyExist:
            return NSLocalizedString("Пользователь с такой почтой уже зарегистрирован.", comment: "")
        case .saveError:
            return NSLocalizedString("Ошибка регистрации. Попробуйте позже.", comment: "")
        case .invalidEmailOrPassword:
            return NSLocalizedString("Неверный пароль или почта, введите заново.", comment: "")
        case .idError:
            return NSLocalizedString("Ошибка информации. Попробуйте позже.", comment: "")
        case .unknownError:
            return NSLocalizedString("Некорректные данные. Введите заново.", comment: "")
        case .blankField:
            return NSLocalizedString("Заполните все поля, введите заново.", comment: "")
        }
    }
}


enum NetworkErrors: Error {
    case wrongBaseURL, dataError, serverError, wrongParameters
}

extension NetworkErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongBaseURL:
            return NSLocalizedString("Некорректная подключение с серверу", comment: "")
        case .dataError:
            return NSLocalizedString("Некорректные данные", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера.", comment: "")
        case .wrongParameters:
            return NSLocalizedString("Некорректные параметры при запросе", comment: "")
        }
    }
}
