//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 04.04.2024.
//

import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}
