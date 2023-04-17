//
//  NetworkService.swift
//  EventPasser
//
//  Created by Arseniy Matus on 22.12.2022.
//

import UIKit

public class NetworkService {
    private init() { }

    public static var shared: NetworkService { NetworkService() }

    public typealias Response = (status: ResponseStatus, data: Any)

    // MARK: POST Requests

    public func register(stringURL: String, username: String, password: String, completion: @escaping (Result<Response, Error>) -> Void) {
        let parameters = [
            "username": username,
            "password": password,
            "confirmPassword": password,
        ]

        do {
            let request = try prepareRequest(urlString: stringURL, parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }

    public func signIn(stringURL: String, username: String, password: String, completion: @escaping (Result<Response, Error>) -> Void) {
        let parameters = [
            "username": username,
            "password": password,
        ]

        do {
            let request = try prepareRequest(urlString: stringURL, parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }
    
    public func deleteUser(stringURL: String, token: String, completion: @escaping(Result<Response, Error>) -> Void) {
        do {
            var request = try prepareRequest(urlString: stringURL, parameters: nil, httpMethod: "DELETE")
            request.setValue(token, forHTTPHeaderField: "authorization")
            
            requestWithResponse(request, completion: completion)
            
        } catch {
            completion(.failure(error))
        }

    }

    // MARK: Prepare functions

    public func prepareRequest(urlString: String, parameters: [String: Any]?, httpMethod: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw (NetworkErrors.wrongBaseURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        do {
            if let parameters {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted, .fragmentsAllowed])
            }
        } catch {
            throw NetworkErrors.wrongParameters
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    public func requestWithResponse(_ request: URLRequest, completion: @escaping (Result<Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(NetworkErrors.serverError))
                    return
                }

                guard let data else {
                    completion(.failure(NetworkErrors.dataError))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    completion(.success((httpResponse.status, data)))
                    return
                }
                completion(.failure(NetworkErrors.serverError))
            }
        }).resume()
    }
}
