//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 29.04.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    static let shared = ProfileService()
    
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    private init() {}
    
    func createProfileRequest() -> URLRequest? {
        
        if task != nil {
            task?.cancel()
        }
        
        let path = "/me"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Ошибка создании URL")
            return nil
        }
        
        let request = URLRequest(url: url)
        
        return request
    }
    
    func fetchProfile(_ token: String,
                      completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = createProfileRequest() else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(profile: profileResult)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                print("Ошибка получения информации профиля: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
