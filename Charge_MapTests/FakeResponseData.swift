//
//  FakeResponseData.swift
//  Charge_MapTests
//
//  Created by Macbook pro on 06/01/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import Foundation

class ErrorProtocol: Error {}

class FakeResponseData {
    
    let incorrectData = "erreur".data(using: .utf8)!
    
    // Weather
    var correctData: Data {
        let data = recoverUrlJSONFiles(nameJson: "JsonWithCorrectData")
        return data
    }
    
    var dataWithAnnotationsEmpty: Data {
        let data = recoverUrlJSONFiles(nameJson: "JsonWithAnnotationsEmpty")
        return data
    }
    
    var dataEmpty: Data {
        let data = recoverUrlJSONFiles(nameJson: "IncorrectJson")
        return data
    }
    
    // All
    let responseOK = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    let responseNotOK =  HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    let responseNotOK2 =  HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 400, httpVersion: nil, headerFields: [:])
    let responseNotTypeHTTPURLResponse = URLResponse(url: URL(string: "www.testURL.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    
    let error = ErrorProtocol()
    
    func recoverUrlJSONFiles(nameJson: String) -> Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: nameJson, withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
}
