//
//  ProfileResponceBody.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 29.04.2024.
//

import Foundation

struct ProfileResult: Codable {
    let firstName: String
    let lastName: String?
    let bio: String?
    let username: String
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(profile: ProfileResult) {
        self.username = profile.username
        self.name = "\(profile.firstName) \(profile.lastName ?? "")"
        self.loginName = "@\(profile.username)"
        self.bio = profile.bio
    }
}
