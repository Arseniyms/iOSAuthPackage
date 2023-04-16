//
//  ResponseStatus.swift
//  EventPasser
//
//  Created by Arseniy Matus on 22.12.2022.
//

import Foundation


public enum ResponseStatus: Int {
    case OK = 200
    case created = 201
    case deleted = 204
    case badRequest = 400
    case unathorized = 401
    case serverError = 500
}

extension HTTPURLResponse {
    
    public var status: ResponseStatus {
        return ResponseStatus(rawValue: statusCode) ?? .serverError
    }
    
}
