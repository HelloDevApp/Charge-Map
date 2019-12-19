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
    URLQueryItem(name: "lang", value: "fr"),
    URLQueryItem(name: "rows", value: "10000"),
    URLQueryItem(name: "facet", value: "nbre_pdc"),
    URLQueryItem(name: "facet", value: "puiss_max"),
    URLQueryItem(name: "facet", value: "accessibilite"),
    URLQueryItem(name: "facet", value: "n_station"),
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

        parameters.append(URLQueryItem(name: "geofilter.distance", value: "\(latitude),\(longitude),40000"))

    }
    
    func getAnnotations(callback: @escaping (Bool, API_Result?) -> Void) {
        addGeofilterUrl(latitude: "48.0909", longitude: "2.0302")
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
    
    func removeDuplicateRecords(result: API_Result) -> [Record?] {
        let recordsWithoutDuplicates = result.records.removeDuplicates()
        Datas.resultAPIObject = recordsWithoutDuplicates
        return recordsWithoutDuplicates
    }
    
    func convert(field: Fields) -> [[Any?]] {
        let mirror = Mirror(reflecting: field)
        let data = Datas()
        
        //        var test = mirror.children.map{ $0 }.filter{ ($0.value is String || $0.value is Int) }
        for child in mirror.children {
            if let label = child.label, let value = child.value as? String {
                data.valuesAfterTypeCheck.append(value)
                data.labelsAfterTypeCheck.append(label)
            } else if let label = child.label, let value = child.value as? Int {
                let valueConverted = String(value)
                data.valuesAfterTypeCheck.append(valueConverted)
                data.labelsAfterTypeCheck.append(label)
            } else if let label = child.label, let value = child.value as? Double {
                let valueConverted = String(value)
                data.valuesAfterTypeCheck.append(valueConverted)
                data.labelsAfterTypeCheck.append(label)
            } else {
                continue
            }
        }
        var array = [[Any]]()
        array.append(data.labelsAfterTypeCheck)
        array.append(data.valuesAfterTypeCheck)
        return array
    }
    
}
