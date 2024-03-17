//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 16.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var profilePhoto: UIImageView!

    @IBOutlet private var profileName: UILabel!

    @IBOutlet private var login: UILabel!

    @IBOutlet private var profileDescription: UILabel!

    @IBOutlet private var exitButton: UIButton!
    
    @IBAction func didTapLogout(_ sender: Any) {
        
    }
    
}
