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
    
    var labelsAfterTypeCheck = [String]()
    var valuesAfterTypeCheck = [String]()
    var annotations = [CustomAnnotation]()
    var coordinatesSelectedAnnotation: CLLocationCoordinate2D?
    
    static var annotationSelected: CustomAnnotation?
    static var resultAPIObject: [Record?]?
    
    // MARK: - Colors
    static let lightRedColor = (red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1)
    
    static let darkRedColor = (red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1)
}
