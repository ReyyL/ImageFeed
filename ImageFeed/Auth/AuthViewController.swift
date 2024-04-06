//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 31.03.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let authSegueIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAuthScreen()
        configureBackButton()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authSegueIdentifier { // 1
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(authSegueIdentifier)")
            }
            
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender) // 7
        }
    }
    
    private func createAuthScreen() {
        
        view.backgroundColor = UIColor(named: "YBlack")
        
        let authImage = UIImageView()
        
        authImage.image = UIImage(named: "Logo_of_Unsplash")
        
        authImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authImage)
        
        
        NSLayoutConstraint.activate([
            authImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            authImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
        ])
        
    }
    
    private func configureBackButton() {
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: #selector(did))
        
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YBlack")
    }
    
    @objc
    func did() {
        print(1111)
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
        print(423)
    }
}


