//
//  ApiTestCase.swift
//  Charge_MapTests
//
//  Created by Macbook pro on 06/01/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import XCTest
@testable import Charge_Map

class ApiTestCase: XCTestCase {
    
    let fakeResponse = FakeResponseData()
    let expectation = XCTestExpectation(description: "wait, for queue change.")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCallShouldReturnCorrectData() {
        
        let apiHelper = ApiHelper(session: URLSessionFake(data: fakeResponse.correctData, response: fakeResponse.responseOK, error: nil))
        apiHelper.getAnnotations { (success, result) in
            XCTAssertTrue(success)
            XCTAssertNotNil(result)
            XCTAssert(result!.records.isEmpty == false)
            self.expectation.fulfill()
            
            self.wait(for: [self.expectation], timeout: 0.01)
        }
    }
    
    func testGetAnnotationsShouldPostFailedCallbackIfNoData() {
        let apihelper = ApiHelper(session: URLSessionFake(data: nil, response: nil, error: fakeResponse.error))
        apihelper.getAnnotations { (success, result) in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            // ajouter response coter apihelper toute la gestion des code erreur et tout
        }
    }

}
