//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 02.03.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)"}
    private let photoDate: Date = .init()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageFromArray = UIImage(named: photosName[indexPath.row]) else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageFromArray.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageFromArray.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let imageFromArray = UIImage(named: photosName[indexPath.row]) else { return }
        
        cell.cellImage.image = imageFromArray
       
        cell.dateLabel.text = dateFormatter.string(from: photoDate)
        
        cell.likeButton.imageView?.image = indexPath.row % 2 == 0
        ? UIImage(named: "like_button_on")
        : UIImage(named: "like_button_off")
    }
}

