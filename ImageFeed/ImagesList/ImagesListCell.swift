//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 03.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var likeButton: UIButton!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var cellImage: UIImageView!
    
    func configureCell(imageFromArray: UIImage?, date: String, isLiked: Bool) {
        
        cellImage.image = imageFromArray
        
        dateLabel.text = date
        
        likeButton.imageView?.image = isLiked
        ? UIImage(named: "like_button_on")
        : UIImage(named: "like_button_off")
    }
}
