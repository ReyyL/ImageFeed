//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 02.03.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)"}
    private let photoDate: Date = .init()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var photos: [Photo] = []
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
        ImagesListService.shared.fetchPhotosNextPage()
        
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageSegueIdentifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        guard let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else {
            assertionFailure("Invalid segue destination")
            return
        }
        
        viewController.fullImageUrl = URL(string: photos[indexPath.row].fullImageURL)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let photoSize = photos[indexPath.row].size
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photoSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photoSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
        
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imagesListCell.delegate = self
        imagesListCell.loadCell(from: photos[indexPath.row])
        
        return imagesListCell
    }
}

extension ImagesListViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == ImagesListService.shared.photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        
        let oldPhotos = photos.count
        let newPhotos = ImagesListService.shared.photos.count
        
        photos = ImagesListService.shared.photos
        
        if oldPhotos != newPhotos {
            
            tableView.performBatchUpdates {
                
                let indexPaths = (oldPhotos..<newPhotos).map { i in
                    IndexPath(row: i, section: 0)
                }
                
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) {
            [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let isLiked):
                self.photos[indexPath.row].isLiked = isLiked
                cell.setIsLiked(isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("\(error.localizedDescription)")
            }
        }
    }
}

