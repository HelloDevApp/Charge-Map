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
    static var powerCar: [Int] {
        var powers: [Int] = []
        for i in 0..<100 {
            powers.append(i)
        }
        return powers
    }
}
