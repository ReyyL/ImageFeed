//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 30.04.2024.
//

import Foundation
import SwiftKeychainWrapper

enum ProfileImageError: Error {
    case invalidProfileImage
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
    }
}

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    
    private var task: URLSessionTask?
    
    private (set) var avatarURL: String?
    
    private init() { }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        let path = "/users/\(username)"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Ошибка создании URL")
            return
        }
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        var request = URLRequest(url: url)
        
        guard let token = KeychainWrapper.standard.string(forKey: "Auth token")  else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) {
            [weak self] (result: Result<UserResult, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.large
                
                guard let profileImageURL = self.avatarURL else { return }
                
                completion(.success(profileImageURL))
                
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": profileImageURL])
                
                self.task = nil
            case .failure(let error):
                print("Ошибка получения фото профиля: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
