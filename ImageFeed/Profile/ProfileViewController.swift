//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 16.03.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
    func switchToSplashController()
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    private var nameLabel = UILabel()
    private var loginLabel: UILabel?
    private var profileDescription: UILabel?
    private var profileImage: UIImageView?
    private var exitButton: UIButton?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileUI()
//        presenter = ProfilePresenter(view: self)
        presenter?.viewDidLoad()
        addObserver()
        updateAvatar()
        
        self.view.accessibilityIdentifier = "ProfileViewController"
    }
    
    func addObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    func updateAvatar() {
        presenter?.updateAvatar(profileImage: profileImage)
    }
    
    func switchToSplashController() {
        presenter?.switchToSplashController()
    }
    
    func updateProfileDetails(profile: Profile?) {
        DispatchQueue.main.async {
            [weak self] in
            guard let self = self, let profile else { return }
            self.nameLabel.text = profile.name
            self.loginLabel?.text = profile.loginName
            self.profileDescription?.text = profile.bio
        }
    }
    
    private func createProfileUI() {
        
        view.backgroundColor = .yBlack
        
        let profileImage = UIImageView()
        self.profileImage = profileImage
        profileImage.layer.cornerRadius = 35
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        view.addSubview(profileImage)
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        nameLabel.textColor = .white
        self.nameLabel = nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let loginLabel = UILabel()
        loginLabel.textColor = UIColor(named: "YGray")
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        self.loginLabel = loginLabel
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        let profileDescription = UILabel()
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        profileDescription.textColor = .white
        self.profileDescription = profileDescription
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescription)
        
        
        let exitButtonImage = UIImage(systemName: "ipad.and.arrow.forward")
        guard let exitButtonImage else { return }
        let exitButton = UIButton.systemButton(with: exitButtonImage,
                                               target: self,
                                               action: #selector(showAlert))
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
    
    @objc private func showAlert() {
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
