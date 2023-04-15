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
    
    typealias Response = (status: ResponseStatus, data: Any)

    // MARK: POST Requests

    func register(isAdmin: Bool, username: String, password: String, completion: @escaping (Result<Response, Error>) -> Void) {
        let parameters = [
            "username": username,
            "password": password,
            "confirmPassword": password,
        ]

        do {
            let path = isAdmin ? "/registerAdmin" : "/register"
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "0" + path, parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }

    func signIn(username: String, password: String, completion: @escaping (Result<Response, Error>) -> Void) {
        let parameters = [
            "username": username,
            "password": password,
        ]

        do {
            let request = try prepareRequest(urlString: Constants.NetworkURL.baseURL + "0/login", parameters: parameters, httpMethod: "POST")

            requestWithResponse(request, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }
    
    func getInfo(of token: String, completion: @escaping (Result<Response, Error>) -> Void) {
        let url = URL(string: Constants.NetworkURL.baseURL + "1/test/jwt/")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(AuthorizationError.idError))
                return
            }
            if let data {
                completion(.success((response.status, data)))
            }
            
        }.resume()
    }

    // MARK: Prepare functions

    private func prepareRequest(urlString: String, parameters: [String: Any], httpMethod: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw (NetworkErrors.wrongBaseURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted, .fragmentsAllowed])
        } catch {
            throw NetworkErrors.wrongParameters
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    private func requestWithResponse(_ request: URLRequest, completion: @escaping (Result<Response, Error>) -> Void) {
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
                }
            }
        }).resume()
    }
}
