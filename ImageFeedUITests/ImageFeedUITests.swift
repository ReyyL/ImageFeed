//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Andrey Lazarev on 20.05.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        
        let loginButton = app.buttons["Authenticate"]
        let webView = app.webViews["UnsplashWebView"]
        let keyboardDone = app.buttons["Done"]
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        let webLoginButton = app.buttons["Login"]
        let tablesQuery = app.tables
        
        loginButton.tap()
        
        XCTAssertTrue(webView.waitForExistence(timeout: 3))
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
        loginTextField.tap()
        loginTextField.typeText("lazarev01@list.ru")
        
        keyboardDone.tap() //по swipeUp и тапу на вебвью клавиатура не скрывалась
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        
        passwordTextField.tap()
        passwordTextField.typeText("_Galaxy555000")
        
        webLoginButton.tap()
        
        sleep(5)
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let setLike = cellToLike.buttons["like button off"]
        let setDislike = cellToLike.buttons["like button on"]
        
        sleep(2)
        
        cell.swipeUp()
        
        sleep(3)
        
        setLike.tap()
        
        sleep(2)
        setDislike.tap()

        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackwardSingle"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        
        let profileTabButton = app.tabBars.buttons.element(boundBy: 1)
        let alertOkButton = app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"]
        let profileName = app.staticTexts["Andrew Lazarev"]
        let profileLogin = app.staticTexts["@reyyyyl"]
        let loginButton = app.buttons["Authenticate"]
        let logoutButton = app.buttons["ipad.and.arrow.forward"]
        
        profileTabButton.tap()
        
        XCTAssertTrue(profileName.waitForExistence(timeout: 3))
        XCTAssertTrue(profileLogin.waitForExistence(timeout: 3))
        
        logoutButton.tap()
        
        print(app.debugDescription)
        alertOkButton.tap()
        
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3))
    }
}
