//
//  RocketDetaiImageCollectionViewCellViewModelTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 21/02/2021.
//

import XCTest
@testable import SpaceXLaunch
import RxSwift

class RocketDetaiImageCollectionViewCellViewModelTests: XCTestCase {
    var sut: RocketDetailImageCollectionViewCellViewModel!
    var cell: RocketDetailImageCollectionViewCell!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        whenSUTSetFromURL()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cell = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testConfigureCell_setsImageViewImageURL() {
        // when
        whenConfigureRocketDetailImageCollectionViewCell()
        let exp = expectation(for: NSPredicate(block: { (cell, _) -> Bool in
            return (cell as! RocketDetailImageCollectionViewCell).imageView.image != nil
        }), evaluatedWith: cell, handler: nil)
        
        // then
        wait(for: [exp], timeout: 2)
    }
    
    func whenSUTSetFromURL(imageURL: URL? = URL(string: "https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg")) {
        sut = RocketDetailImageCollectionViewCellViewModel(imageURL: imageURL)
    }
    
    func givenRocketDetailImageCollectionViewCell() {
        let viewController = RocketDetailViewController.instanceFromStoryboard()
        viewController.loadViewIfNeeded()
        
        let collectionView = viewController.collectionView!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RocketDetailImageCollectionViewCell.self)", for: IndexPath(item: 0, section: 0)) as? RocketDetailImageCollectionViewCell
    }

    // MARK: - When
    func whenConfigureRocketDetailImageCollectionViewCell() {
        givenRocketDetailImageCollectionViewCell()
        sut.configure(cell)
    }
}
