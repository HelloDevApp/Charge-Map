//
//  ProtocolUrlEncorder.swift
//  Charge_Map
//
//  Created by Macbook pro on 23/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation

protocol UrlEncoder {
    
    func createUrlBase(scheme: String, host: String, path: String?) -> URL?
    func encode(urlBase: URL, parameters: [(String, String)]) -> URL?
    
}

extension UrlEncoder {
    
    func createUrlBase(scheme: String, host: String, path: String?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host   = host
        if let path = path {
            urlComponents.path   = path
        }
        guard let url = urlComponents.url else { return nil }
        return url
    }
    
    func encode(urlBase: URL, parameters: [(String, String)]) -> URL? {
        guard var urlComponents = URLComponents(url: urlBase, resolvingAgainstBaseURL: false) else { return urlBase }
        urlComponents.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem =  URLQueryItem(name: key, value: value)
            urlComponents.queryItems?.append(queryItem)
        }
        guard let url = urlComponents.url else { return urlBase }
        return url
    }
}
