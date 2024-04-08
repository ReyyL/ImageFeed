//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 08.04.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    private let tokenKey = "Bearer Token"
    
     var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
