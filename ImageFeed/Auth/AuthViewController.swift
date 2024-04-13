//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 31.03.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    
    private let authSegueIdentifier = "ShowWebViewSegueIdentifier"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAuthScreen()
        configureBackButton()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(authSegueIdentifier)")
            }
            
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
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
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackwardWebView")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YBlack")
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        
        oauth2Service.fetchOAuthToken(code: code) { [self] result in
            switch result {
            case .success:
                delegate?.didAuthenticate(self)
                
            case .failure:
                // TODO [Sprint 11]
                break
            }
        }
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}


