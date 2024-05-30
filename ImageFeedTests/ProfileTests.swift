//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Andrey Lazarev on 19.05.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    let view = ProfileViewController()
    let presenter = ProfilePresenterSpy()
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let view = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        view.presenter = presenter
        presenter.view = view
        
        //when
        _ = view.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testDidAvatarUpdate() {
        //given
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(view: view)
        view.presenter = presenter
        
        //when
        view.updateAvatar()
        
        //then
        XCTAssertTrue(view.didAvatarUpdate)
    }
    
    func testDidProfileUpdate() {
        //given
        let view = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(view: view)
        view.presenter = presenter
        let testUser = Profile(profile: ProfileResult(firstName: "test", lastName: "test", bio: "testBio", username: "testUsername"))
        
        //when
        view.updateProfileDetails(profile: testUser)
        
        //then
        XCTAssertTrue(view.didProfileUpdate)
        XCTAssertEqual(view.descriptionLabel.text, "testBio")
        XCTAssertEqual(view.userNameLabel.text, "test test")
        XCTAssertEqual(view.loginLabel.text, "@testUsername")
    }
}
