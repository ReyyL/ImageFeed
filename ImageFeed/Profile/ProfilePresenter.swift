//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 19.05.2024.
//

import Foundation
import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar(profileImage: UIImageView?)
    func switchToSplashController()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    init(view: ProfileViewControllerProtocol?) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.updateProfileDetails(profile: ProfileService.shared.profile)
    }
    
    func updateAvatar(profileImage: UIImageView?) {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        
        profileImage?.kf.setImage(with: url)
    }
    
    func switchToSplashController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            window.rootViewController = SplashViewController()
        }
    }
}
