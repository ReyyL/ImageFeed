//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Andrey Lazarev on 19.05.2024.
//

@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    var didAvatarUpdate = false
    var didProfileUpdate = false
    
    var userNameLabel = UILabel()
    var loginLabel = UILabel()
    var descriptionLabel = UILabel()
    
    func updateAvatar() {
        didAvatarUpdate = true
    }
    
    func updateProfileDetails(profile: Profile?) {
        didProfileUpdate = true
        if let profile {
            userNameLabel.text = profile.name
            loginLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
    }
    
    func switchToSplashController() { }
}
