//
//  CustomAnnotation.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import  MapKit

enum AnnotationType : String {
    case free = "free"
    case paid = "paid"
}

class CustomAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var type: AnnotationType
    var field: Fields?
    var numberOfCellForDetailOfField = 0
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, type: AnnotationType, field: Fields?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.type = type
        self.field = field
    }
}

