//
//  CategoriesListViewModelTests.swift
//  chuck-factsTests
//
//  Created by Danilo Camarotto on 21/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import XCTest
import OHHTTPStubs
import RxSwift
@testable import chuck_facts

class CategoriesListViewModelTests: XCTestCase {
    
    let defaultHeaders = ["Content-Tyoe" : "application/json"]
    let bag = DisposeBag()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        OHHTTPStubs.removeAllStubs()
    }
    
    func testFetchCategories() {
        stub(condition: isPath("/jokes/categories")) { [weak self] _ in
            guard let self = self else {
                preconditionFailure("Self can not be nil.")
            }
            let stubPath = OHPathForFile("categories.json", type(of: self))
            return fixture(filePath: stubPath!, headers: self.defaultHeaders)
        }
        
        let viewModel = CategoriesListViewModel()
        let expect = expectation(description: #function)
        
        viewModel.categories
            .subscribe(onNext: { category in
                XCTAssertEqual(category.first?.name, "animal")
                XCTAssertEqual(category[10].name, "music")
                XCTAssertEqual(category.last?.name, "travel")
                expect.fulfill()
        }).disposed(by: bag)
        
        viewModel.fetchCategories()
        waitForExpectations(timeout: 0.5)
    }
    
    func testFetchCategoriesNOK() {
        stub(condition: isPath("/jokes/categories")) { [weak self] _ in
            guard let self = self else {
                preconditionFailure("Self can not be nil.")
            }
            let stubPath = OHPathForFile("categories.json", type(of: self))
            return fixture(filePath: stubPath!, status: 400, headers: self.defaultHeaders)
        }
        
        let viewModel = CategoriesListViewModel()
        let expect = expectation(description: #function)
        
        viewModel.fetchError
            .subscribe(onNext: { error in
                XCTAssertNotNil(error)
                expect.fulfill()
        }).disposed(by: bag)
        
        viewModel.fetchCategories()
        waitForExpectations(timeout: 0.5)
    }
}
