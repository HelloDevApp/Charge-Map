//
//  CustomAnnotationView.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import MapKit

class CustomAnnotationView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            if let annotation = newValue as? CustomAnnotation {
                switch annotation.type {
                case .free:
                    clusteringIdentifier = "free"
                    markerTintColor = #colorLiteral(red: 0.1888821515, green: 0.3201708225, blue: 0.09634789075, alpha: 1)
                case .paid:
                    clusteringIdentifier = "paid"
                    markerTintColor = #colorLiteral(red: 0.5031573834, green: 0.05732172723, blue: 0.05732172723, alpha: 1)
                }
            }
        }
    }
}
