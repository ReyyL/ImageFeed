//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 16.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var profileDescription: UILabel?
    private var profileImage: UIImageView?
    private var exitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileUI()
    }
    
    private func createProfileUI() {
        
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "Photo")
        self.profileImage = profileImage
        profileImage.translatesAutoresizingMaskIntoConstraints = false
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
        
        deleteLabel(&nameLabel)
        deleteLabel(&loginLabel)
        deleteLabel(&profileDescription)
        profileImage?.image = UIImage(systemName: "person.crop.circle.fill")
        profileImage?.tintColor = .gray
        exitButton?.isHidden = true
    }
    
    private func deleteLabel(_ label: inout UILabel?) {
        label?.removeFromSuperview()
        label = nil
    }
    
}
