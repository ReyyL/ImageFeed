//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Andrey Lazarev on 19.05.2024.
//

@testable import ImageFeed
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var photosCount: Int = 0
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var updateTableViewAnimatedCalled = false
    
    var calcHeightForRowAtCalled = false
    var calcHeightForRowAtGotIndex = false
    
    var checkWillDisplayNextPageCalled = false
    var checkWillDisplayNextPageGotIndex = false
    
    var returnPhotoCalled = false
    var returnPhotoGotIndex = false
    
    var imagesListCellDidTapLikeCalled = false
    var imagesListCellDidTapLikeGotIndex = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func calculateRowHeight(indexPath: IndexPath) -> CGFloat {
        calcHeightForRowAtCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            calcHeightForRowAtGotIndex = true
        }
        return CGFloat(100)
    }
    
    func willDisplayNextPage(indexPath: IndexPath) {
        checkWillDisplayNextPageCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            checkWillDisplayNextPageGotIndex = true
        }
    }
    
    func returnPhoto(indexPath: IndexPath) -> Photo? {
        returnPhotoCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            returnPhotoGotIndex = true
        }
        return nil
    }
    
    func didTapLike(cell: ImagesListCell) {
        imagesListCellDidTapLikeCalled = true
        if view?.tableView.indexPath(for: cell) == IndexPath(row: 1, section: 0) {
            imagesListCellDidTapLikeGotIndex = true
        }
    }
}
