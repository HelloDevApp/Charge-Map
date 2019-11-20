//
//  API_Helper.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation

class API_Helper {
    
    private var task: URLSessionDataTask?
    
    var parameters: [URLQueryItem] = [
    URLQueryItem(name: "dataset", value: "fichier-consolide-des-bornes-de-recharge-pour-vehicules-electriques-irve"),
    URLQueryItem(name: "rows", value: "200"),
    URLQueryItem(name: "facet", value: "nom_enseigne"),
    
    URLQueryItem(name: "facet", value: "nbre_pdc"),
    URLQueryItem(name: "facet", value: "puiss_max"),
    URLQueryItem(name: "facet", value: "accessibilite"),
    URLQueryItem(name: "facet", value: "commune"),
    URLQueryItem(name: "facet", value: "nom_dep"),
    URLQueryItem(name: "facet", value: "nom_reg"),
    URLQueryItem(name: "facet", value: "nom_epci"),
    ]
    
    private func createURL() -> URLComponents {
        
        var url = URLComponents()
        url.scheme = "https"
        url.host   = "public.opendatasoft.com"
        url.path   = "/api/records/1.0/search"
        url.queryItems = parameters
        
        return url
    }
    
    func addGeofilterUrl(latitude: String, longitude: String) {
        
        parameters.append(URLQueryItem(name: "geofilter.distance", value: "\(latitude),\(longitude),90000"))
        
    }
    
    func getAnnotions(callback: @escaping (Bool, API_Result?) -> Void) {
        if let url = createURL().url {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else { return }
                
                do {
                    let json = try JSONDecoder().decode(API_Result.self, from: data)
                    callback(true, json)
                } catch {
                    callback(false, nil)
                }
            }
            task.resume()
        }
    }
}
