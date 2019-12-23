//
//  API_Helper.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation

class ApiHelper {
    
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
    
    // method that adds a parameter to the request to retrieve only nearby annotations
    func addGeofilterUrl(latitude: String, longitude: String) {
        parameters.append(URLQueryItem(name: "geofilter.distance", value: "\(latitude),\(longitude),40000"))
    }
    
    // Allows to launch the network call to the api and returns a json in the callback if it's ok, else returns Nil
    func getAnnotations(callback: @escaping (Bool, ApiResult?) -> Void) {
        addGeofilterUrl(latitude: "48.0909", longitude: "2.0302")
        if let url = createURL().url {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else { return }
                
                do {
                    let json = try JSONDecoder().decode(ApiResult.self, from: data)
                    callback(true, json)
                } catch {
                    callback(false, nil)
                }
            }
            task.resume()
        }
    }
    
    /// Allows to delete duplicates annotation returned by the api
    func removeDuplicateRecords(result: ApiResult, annotationManager: AnnotationManager) -> [Record?] {
        let recordsWithoutDuplicates = result.records.removeDuplicates()
        annotationManager.apiAnnotationWithoutDuplicates = recordsWithoutDuplicates
        return recordsWithoutDuplicates
    }
    
    /// Allows to convert the field of an annotation to return an array containing two other arrays:  one containing the name of the properties and one containing the values associated with the properties
    func convert(field: Fields, annotationManager: AnnotationManager) -> [[Any?]] {
        let mirror = Mirror(reflecting: field)
        annotationManager.labelsFieldAfterConvert.removeAll()
        annotationManager.valuesFieldAfterConvert.removeAll()
        // This loop allows to retrieve the name of the properties and their values to add them to the corresponding table
        for child in mirror.children {
            if let label = child.label, let value = child.value as? String {
                annotationManager.valuesFieldAfterConvert.append(value)
                annotationManager.labelsFieldAfterConvert.append(label)
            } else if let label = child.label, let value = child.value as? Int {
                let valueConverted = String(value)
                annotationManager.valuesFieldAfterConvert.append(valueConverted)
                annotationManager.labelsFieldAfterConvert.append(label)
            } else if let label = child.label, let value = child.value as? Double {
                let valueConverted = String(value)
                annotationManager.valuesFieldAfterConvert.append(valueConverted)
                annotationManager.labelsFieldAfterConvert.append(label)
            } else {
                continue
            }
        }
        var array = [[Any]]()
        array.append(annotationManager.labelsFieldAfterConvert)
        array.append(annotationManager.valuesFieldAfterConvert)
        return array
    }
    
}
