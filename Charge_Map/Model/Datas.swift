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
    
    static var startPointGradient = CGPoint(x: 0.0, y: 0.4)
    static var endPointGradient = CGPoint(x: 0.4, y: 1.0)
    
    let coordinateUser = CLLocationCoordinate2D(latitude: 48.0909, longitude: 2.0302)
    var setRegionMeters = (latitude: CLLocationDistance(90000), longitude: CLLocationDistance(90000))
    let alpha: CGFloat = 1.0
    var cornerRadius: CGFloat = 0
    // MARK: - Colors
    let lightRedColor = (red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1)
    let darkRedColor = (red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1)
}
