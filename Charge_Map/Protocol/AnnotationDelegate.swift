//
//  AnnotationDelegate.swift
//  Charge_Map
//
//  Created by Macbook pro on 05/01/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import MapKit

protocol AnnotationDelegate {}

extension AnnotationDelegate {
    
    func filterFreeAnnotations(annotations: [CustomAnnotation]) -> [CustomAnnotation] {
        let filter = annotations.filter { ($0.field?.acces_recharge == "Gratuit" || $0.field?.acces_recharge == "gratuit") }
        return filter
    }
    
    func removeFilterAnnotation(annotationManager: AnnotationManager, mapView: MKMapView) {
        mapView.removeAllAnnotations()
        mapView.addAnnotations(annotationManager.annotations)
    }
    
}
