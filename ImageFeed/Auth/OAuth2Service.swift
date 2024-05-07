//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 07.04.2024.
//

import Foundation
import SwiftKeychainWrapper

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private var authToken: String? {
        get { OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue }
    }
    
    private init() {}
    
    private func createOAuthRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {
            preconditionFailure("Unable to recognize url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        lastCode = code
        guard
            let request = createOAuthRequest(code: code)         
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] 
            (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
                
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
}
