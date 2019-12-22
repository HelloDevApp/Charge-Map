//
//  Datas.swift
//  Charge_Map
//
//  Created by Macbook pro on 10/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation
import MapKit

class Datas {
    
    // array containing the name of the properties of the json returned by the api
    var labelsAfterTypeCheck = [String]()
    
    // array containing the property values of the json returned by the api
    var valuesAfterTypeCheck = [String]()
    
    // table containing all the annotations retrieved from the api
    var annotations = [CustomAnnotation]()
    
    // contains the gps coordinates of the annotation that has been selected
    var coordinatesSelectedAnnotation: CLLocationCoordinate2D?
    
    // contains the selected annotation
    static var annotationSelected: CustomAnnotation?
    
    
    static var resultAPIRecordsWithoutDuplicate: [Record?]?
    
    // MARK: - Colors
    static let lightRedColor = (red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1)
    
    static let darkRedColor = (red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1)
}
