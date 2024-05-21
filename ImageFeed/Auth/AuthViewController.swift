//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 31.03.2024.
//

import UIKit
import ProgressHUD
import SwiftKeychainWrapper

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    
    private let authSegueIdentifier = "ShowWebViewSegueIdentifier"
    
    @IBOutlet var loginButton: UIButton!
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAuthScreen()
        configureBackButton()
        setUpAccessibility()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(authSegueIdentifier)")
            }
            
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter  
            webViewPresenter.view = webViewViewController
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
    
    private func setUpAccessibility() {
        loginButton.accessibilityIdentifier = "Authenticate"
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                
                self.delegate?.didAuthenticate(self)
                
            case .failure(let error):
                
                showAlert()
                print("Ошибка при получении токена: \(error.localizedDescription)")
                
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}



