//
//  Food_for_allTests.swift
//  Food for allTests
//
//  Created by Michael Maher on 2/8/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import XCTest
@testable import Food_for_all

class Food_for_allTests: XCTestCase {
    
    var homeViewModel: HomeViewModel?
    var homeViewController: HomeViewController?
    var tagsTableCell: TagsTableCell?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        homeViewModel = HomeViewModel()
        homeViewController = HomeViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homeViewModel = nil
        homeViewController = nil
    }

    func testFetchingTagsList() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Tags Request")

        homeViewModel?.loadTagsData(page: TagsModel.page, tagsCompletionHandler: { (tags) in
            XCTAssertTrue(!tags.isEmpty, "Tags list are empty !!")
            promise.fulfill()
        }, failure: { (errorMsg) in
            XCTAssert(errorMsg.isEmpty, "ErrorOcurred: \(errorMsg) !!")
            promise.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testFetchingNewTagsPage() {
          // This is an example of a functional test case.
          // Use XCTAssert and related functions to verify your tests produce the correct results.
         self.homeViewModel?.tagsList = [Tags](repeating: Tags(tagName: "Test Tag", photoURL: "test path"), count: 8)
          TagsModel.page += 1
          let promise = expectation(description: "Tags Request")

          homeViewModel?.loadTagsData(page: TagsModel.page, tagsCompletionHandler: { (tags) in
            XCTAssertTrue(self.homeViewModel?.tagsList.count == (tags.count * TagsModel.page), "cann't get new tags page")
              promise.fulfill()
          }, failure: { (errorMsg) in
              XCTAssert(errorMsg.isEmpty, "ErrorOcurred: \(errorMsg) !!")
              promise.fulfill()
          })
          waitForExpectations(timeout: 5, handler: nil)

      }
    
    func testFetchingSingleTagList() {
          // This is an example of a functional test case.
          // Use XCTAssert and related functions to verify your tests produce the correct results.
          let tagName = "1- Egyption"
          let promise = expectation(description: "Single tag data Request")

          homeViewModel?.loadSingleTagData(tagName: tagName, tagItemsCompletionHandler: { (tags) in
              XCTAssertTrue(!tags.isEmpty, "Tags list are empty !!")
              promise.fulfill()
          }, failure: { (errorMsg) in
              XCTAssert(errorMsg.isEmpty, "ErrorOcurred: \(errorMsg) !!")
              promise.fulfill()
          })
          waitForExpectations(timeout: 5, handler: nil)

      }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
