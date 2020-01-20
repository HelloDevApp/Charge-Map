//
//  AnnotationManager.swift
//  Charge_Map
//
//  Created by Macbook pro on 22/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

class AnnotationManager {

    let datas = Datas()
    
    var filterFreeIsOn = false
    var filterGetAllAnnotationsIsOn = false
    
    // array containing the name of the properties of the json returned by the api
    var labelsFieldAfterConvert = [String]()
    
    // array containing the property values of the json returned by the api
    var valuesFieldAfterConvert = [String]()
    
    // table containing all the annotations (OBJECT CLASS) retrieved from the api
    var annotations = [CustomAnnotation]()
    
    // ** CONTAIN ALL ANNOTATIONS INFO RETRIEVE FROM API AFTER REMOVE DUPLICATES **
    var apiAnnotationWithoutDuplicates: [Record?]?
    
    // contains the selected annotation
    var annotationSelected: CustomAnnotation?

    func createAnnotation(annotation: Record) -> (lat: Double, long: Double, title: String, subtitle: String, paidorFree: AnnotationType, fields: Fields)? {
        guard let fields = annotation.fields else { return nil }
        if let latitude = annotation.fields?.coordonnees?.first,
            let longitude = annotation.fields?.coordonnees?.last {
            let title = fields.n_station ?? Word.empty
            let subtitle = fields.accessibilite ?? Word.empty
            let paidOrFree: AnnotationType = (fields.acces_recharge == Word.free.capitalized || fields.acces_recharge == Word.free) ? .free : .paid
            return (latitude, longitude, title, subtitle, paidOrFree, fields)
        }
        return nil
    }
}
