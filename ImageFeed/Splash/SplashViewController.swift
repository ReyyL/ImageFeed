//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 10.04.2024.
//

import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    
    private let splashViewIdentifier = "SplashViewSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let token = OAuth2TokenStorage().token
        
        if token != nil {
            guard let token else { return }
            fetchProfile(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController,
                  let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Ошибка \("NavigationController")")
                return
            }
            authViewController.delegate = self
            navigationController.modalPresentationStyle = .fullScreen
            authViewController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    
    private func createSplashUI() {
        let image = UIImageView()
        image.image = UIImage(named: "Vector")
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarViewController")
            
            window.rootViewController = tabBarController
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = OAuth2TokenStorage().token else {
            return
        }
        
        fetchProfile(token)
    }
    
    func fetchProfile(_ token: String) {

        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            
            guard let self = self else { return }
            
            UIBlockingProgressHUD.show()
            
            switch result {
            case .success(_):
                guard let username = ProfileService.shared.profile?.username else { return }
                
                self.switchToTabBarController()
                
                UIBlockingProgressHUD.dismiss()
                
                ProfileImageService.shared.fetchProfileImageURL(username: username) { result in
                    switch result {
                    case .success(_): break
                    case .failure(let error):
                        print("Error \(error)")
                    }
                }
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }
}
