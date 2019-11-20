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
    let parameters: Parameters
    let records: [Record]
    let facet_groups: [FacetGroup]?
}

// MARK: - FacetGroup
struct FacetGroup: Decodable {
    let facets: [Facet]
    let name: String
}

// MARK: - Facet
struct Facet: Decodable {
    let count: Int
    let path: String
    let state: String
    let name: String
}

// MARK: - Parameters
struct Parameters: Decodable {
    let dataset: String
    let timezone: String
    let rows: Int
    let start: Int?
    let format: String
    let facet: [String]
}

// MARK: - Record
struct Record: Decodable {
    let datasetid: String
    let recordid: String
    let fields: Fields?
    let geometry: Geometry?
    let record_timestamp: String
}

// MARK: - Fields
struct Fields: Decodable {
    let nom_reg: String?
    let accessibilite: String?
    let id_station: String?
    let code_insee: String?
    let acces_recharge: String?
    let n_amenageur: String?
    let ad_station: String?
    let date_maj: String?
    let source: String?
    let puiss_max: Double?
    let observations: String?
    let n_station: String?
    let id_pdc: String?
    let nbre_pdc: Int?
    let code_epci: String?
    let commune: String?
    let nom_epci: String?
    let nom_dep: String?
    let coordonnees: [Double?]?
    let type_prise: String?
    let n_enseigne: String?
    let n_operateur: String?
}

// MARK: - Geometry
struct Geometry: Decodable {
    let type: String
    let coordinates: [Double]
}

