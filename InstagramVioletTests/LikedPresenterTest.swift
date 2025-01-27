//
//  LikedPresenterTest.swift
//  InstagramVioletTests
//
//  Created by Владислав Артюхов on 26.01.2025.
//

import XCTest
@testable import InstagramViolet

class MockView: LikedViewProtocol {
    var titleTest: String?
    func setLikedPosts(likedPosts: InstagramViolet.LikedPost) {
        self.titleTest = likedPosts.caption
    }
    
    
}

final class LikedPresenterTest: XCTestCase {

    var view: MockView!
    var likedPost: LikedPost!
    var presenter: LikedPresenter!
    
    override func setUpWithError() throws {
        view = MockView()
        likedPost = LikedPost(imageUrl: nil, user: nil, caption: "Baz", creationDate: nil)
        presenter = LikedPresenter(view: view, likedPost: likedPost)
    }

    override func tearDownWithError() throws {
        view = nil
        likedPost = nil
        presenter = nil
    }
    
    func testModuleIsNotNil() {
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(presenter, "view is not nil")
        XCTAssertNotNil(likedPost, "view is not nil")
    }

    func testView() {
        presenter.showLikedPosts()
        XCTAssertEqual(view.titleTest, "Baz")
    }

    func testLikedModel() {
        XCTAssertEqual(likedPost.caption, "Baz")
        XCTAssertEqual(likedPost.id, nil)
    }
}
