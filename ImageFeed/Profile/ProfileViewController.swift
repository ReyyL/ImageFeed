//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 16.03.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    
    private var nameLabel = UILabel()
    private var loginLabel: UILabel?
    private var profileDescription: UILabel?
    private var profileImage: UIImageView?
    private var exitButton: UIButton?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileUI()
        guard let profile = ProfileService.shared.profile else { return }
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        profileImage?.kf.setImage(with: url)
        
    }
    
    private func updateProfileDetails(profile: Profile) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self else { return }
            self.nameLabel.text = profile.name
            self.loginLabel?.text = profile.loginName
            self.profileDescription?.text = profile.bio
        }
    }
    
    private func createProfileUI() {
        
        view.backgroundColor = .yBlack

        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "Photo")
        self.profileImage = profileImage
        profileImage.layer.cornerRadius = 35
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        view.addSubview(profileImage)
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        nameLabel.textColor = .white
        self.nameLabel = nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YGray")
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        self.loginLabel = loginLabel
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        let profileDescription = UILabel()
        profileDescription.text = "Hello, World!"
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        profileDescription.textColor = .white
        self.profileDescription = profileDescription
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescription)
        
        
        let exitButtonImage = UIImage(systemName: "ipad.and.arrow.forward")
        guard let exitButtonImage else { return }
        let exitButton = UIButton.systemButton(with: exitButtonImage,
                                               target: self,
                                               action: #selector(didTapLogout))
        exitButton.tintColor = UIColor(named: "YRed")
        self.exitButton = exitButton
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: 32),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                  constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor,
                                           constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                            constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            profileDescription.topAnchor.constraint(equalTo: loginLabel.bottomAnchor,
                                                    constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -24)
        ])
        
    }
    
    
    @objc func didTapLogout(_ sender: Any) {
        showAlert()
    }
    
    private func deleteLabel(_ label: inout UILabel?) {
        label?.removeFromSuperview()
        label = nil
    }
    
    private func switchToSplashController() {
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            window.rootViewController = SplashViewController()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Да", style: .default) { _ in
            
            ProfileLogoutService.shared.logout()
            self.switchToSplashController()
        }
        let secondAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        alert.addAction(secondAction)
        present(alert, animated: true)
    }
    
}
