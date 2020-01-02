//
//  API_Helper.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation

class ApiHelper: UrlEncoder {
    
    var scheme: String = Word.https
    var host: String = Word.hostApi
    var path: String = Word.path
    
    private var task: URLSessionDataTask?
    
    var parameters: [(key: String, value: String)] =
        [(Word.dataset.0, Word.dataset.1),
         (Word.lang.0 , Word.lang.1),
         (Word.rows.0 , Word.rows.1),
         (Word.numberOutletsFacet.0, Word.numberOutletsFacet.1),
         (Word.powerFacet.0, Word.powerFacet.1),
         (Word.accessibilityFacet.0, Word.accessibilityFacet.1),
         (Word.nameStationFacet.0, Word.nameStationFacet.1)]
    
    // method that adds a parameter to the request to retrieve only nearby annotations
    func addGeofilterUrl(latitude: String, longitude: String) {
        for (offset, element: (key, _)) in parameters.enumerated() {
            if key != Word.geofilterDistance  {
                continue
            } else {
                parameters.remove(at: offset)
            }
        }
        parameters.append((key: Word.geofilterDistance, value: "\(latitude),\(longitude),50000"))
    }
    
    private func removeGeofilterUrl() {
        for (offset, element: (key, _)) in parameters.enumerated() {
            if key == Word.geofilterDistance {
                parameters.remove(at: offset)
            }
        }
    }
    
    // Allows to launch the network call to the api and returns a json in the callback if it's ok, else returns Nil
    func getAnnotations(callback: @escaping (Bool, ApiResult?) -> Void) {
//        addGeofilterUrl(latitude: "48.0909", longitude: "2.0302")
        if let urlBase = createUrlBase(scheme: self.scheme, host: self.host, path: self.path),
            let url = encode(urlBase: urlBase, parameters: parameters) {
            print(url)
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
        removeGeofilterUrl()
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
