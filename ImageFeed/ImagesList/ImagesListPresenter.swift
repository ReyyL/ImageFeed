//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 19.05.2024.
//

import UIKit

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func calculateRowHeight(indexPath: IndexPath) -> CGFloat
    func didTapLike(cell: ImagesListCell)
    func updateTableViewAnimated()
    func willDisplayNextPage(indexPath: IndexPath)
    func returnPhoto(indexPath: IndexPath) -> Photo?
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    func viewDidLoad() {
        ImagesListService.shared.fetchPhotosNextPage()
        
        view?.setupTableView()
    }
    
    weak var view: ImagesListViewControllerProtocol?
    
    private var photos: [Photo] = []
    var photosCount: Int { photos.count }
    
    func calculateRowHeight(indexPath: IndexPath) -> CGFloat {
        
        guard let view else { return 0 }
        
        let photoSize = photos[indexPath.row].size
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = view.tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photoSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photoSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
        
    }
    
    func returnPhoto(indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
    
    func willDisplayNextPage(indexPath: IndexPath) {
        if indexPath.row + 1 == ImagesListService.shared.photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func didTapLike(cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        
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
    
    func updateTableViewAnimated() {
        let oldPhotos = photos.count
        let newPhotos = ImagesListService.shared.photos.count
        
        photos = ImagesListService.shared.photos
        
        if oldPhotos != newPhotos {
            
            view?.tableView.performBatchUpdates {
                
                let indexPaths = (oldPhotos..<newPhotos).map { i in
                    IndexPath(row: i, section: 0)
                }
                
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}
