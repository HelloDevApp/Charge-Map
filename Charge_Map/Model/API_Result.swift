//
//  API_Result.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation

struct API_Result: Decodable {
    let nhits: Int?
    let records: [Record?]
}

struct Record: Decodable, Equatable {
    let fields: Fields?
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.fields?.coordonnees == rhs.fields?.coordonnees ? true : false
    }
}

struct Fields: Decodable {
    let type_prise: String?
//    let source: String?
    let ad_station: String?
    let date_maj: String?
    let accessibilite: String?
    let n_station: String?
    let coordonnees: [Double]?
    let acces_recharge: String?
    let nbre_pdc: Int?
    let puiss_max: Double?
    
    func countProperties() -> Int {
        var valuesFilterArray = [Any]()
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let value = child.value as? String {
                valuesFilterArray.append(value)
            } else if let value = child.value as? Int {
                let valueConverted = String(value)
                valuesFilterArray.append(valueConverted)
            } else if let value = child.value as? Double {
                let valueConverted = String(value)
                valuesFilterArray.append(valueConverted)
            } else {
                continue
            }
        }
        return valuesFilterArray.count
    }
}
