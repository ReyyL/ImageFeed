//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 03.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
}
