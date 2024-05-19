//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 03.03.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

public final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet private weak var likeButton: UIButton!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var cellImage: UIImageView!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let isLiked = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        
        likeButton.setImage(isLiked, for: .normal)
    }
    
    func loadCell(from photo: Photo) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            guard let data = photo.createdAt,
                  let photoURL = URL(string: photo.largeImageURL) else { return }
            
            let date = dateFormatter.string(from: data)
            
            setIsLiked(photo.isLiked)
            
            self.cellImage.kf.indicatorType = .activity
            
            self.cellImage.kf.setImage(with: photoURL,
                                       placeholder: UIImage(named: "photoPlaceholder")) { _ in }
            
            self.dateLabel.text = date
        }
        
        
    }
}
