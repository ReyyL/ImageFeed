//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 04.05.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    private let tokenKey = "Auth Token"

     var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            KeychainWrapper.standard.set(newValue!, forKey: tokenKey)
        }
    }
    
    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
    }
}
