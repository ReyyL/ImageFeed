//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Andrey Lazarev on 19.05.2024.
//

@testable import ImageFeed
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled = false
    var viewDidSwitchToSplash = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar(profileImage: UIImageView?) { }
    
    func switchToSplashController() { 
        viewDidSwitchToSplash = true
    }
}
