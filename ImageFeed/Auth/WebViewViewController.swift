//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 31.03.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuthView()
        webView.navigationDelegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new, 
            context: nil)
        
        updateProgress()
    }
    
    
    //TODO: - добавить нормальную реализацию дисмисса при тапе на назад
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        if isMovingFromParent {
//            delegate?.webViewViewControllerDidCancel(self)
//        }
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    private func loadAuthView() {
        
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),                  //2
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),             //3
            URLQueryItem(name: "response_type", value: "code"),                 //4
            URLQueryItem(name: "scope", value: Constants.accessScope)                     //5
        ]
        
        guard let url = urlComponents.url else {
            return
        }                                         //6
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView( _ webView: WKWebView,
                  decidePolicyFor navigationAction: WKNavigationAction,
                  decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                         //1
            let urlComponents = URLComponents(string: url.absoluteString),  //2
            urlComponents.path == "/oauth/authorize/native",                //3
            let items = urlComponents.queryItems,                           //4
            let codeItem = items.first(where: { $0.name == "code" })        //5
        {
            return codeItem.value                                           //6
        } else {
            return nil
        }
    }
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
