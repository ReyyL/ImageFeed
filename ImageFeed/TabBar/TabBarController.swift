//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 02.05.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let imagesListPresenter = ImagesListPresenter()
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else { return }
        imagesListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListPresenter
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(view: profileViewController)
        profileViewController.presenter = profilePresenter
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ActiveProfile"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
