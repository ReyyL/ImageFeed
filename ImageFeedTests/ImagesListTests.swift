//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Andrey Lazarev on 19.05.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    
    let view = ImagesListViewController()
    let presenter = ImagesListPresenterSpy()
    let indexPath = IndexPath(row: 1, section: 0)
    
    override func setUpWithError() throws {
        // given
        view.presenter = presenter
        presenter.view = view
    }
    
    func testViewControllerCallViewDidLoad() {
        
        // when
        _ = view.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testUpdateTableViewAnimated() {
        // when
        _ = view.view
        presenter.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(presenter.updateTableViewAnimatedCalled)
    }
    
    func testCalculateRowHeight() {
        // when
        _ = view.view
        let result = presenter.calculateRowHeight(indexPath: indexPath)
        
        // then
        XCTAssertTrue(presenter.calcHeightForRowAtCalled)
        XCTAssertTrue(presenter.calcHeightForRowAtGotIndex)
        XCTAssertEqual(result, CGFloat(100))
    }
    
    func testCheckNeedLoadNextPhotos() {
        // when
        _ = view.view
        presenter.willDisplayNextPage(indexPath: indexPath)
        
        // then
        XCTAssertTrue(presenter.checkWillDisplayNextPageCalled)
        XCTAssertTrue(presenter.checkWillDisplayNextPageGotIndex)
    }
    
    func testReturnPhoto() {
        // when
        _ = view.view
        _ = presenter.returnPhoto(indexPath: indexPath)
        
        // then
        XCTAssertTrue(presenter.returnPhotoCalled)
        XCTAssertTrue(presenter.returnPhotoGotIndex)
    }
    
    
}
