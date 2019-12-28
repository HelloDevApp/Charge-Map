//
//  word.swift
//  Charge_Map
//
//  Created by Macbook pro on 22/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation

// Contains all the strings of the project
class Word {
    // MARK: - Segue Identifier
    static let mapVCToTableVC = "mapVCToTableVC"
    static let mapVCToDetailVC = "mapVCToDetailVC"
    
    // MARK: - Cell Identifier
    static let customCell = "customCell"
    
    // MARK: - Fields Annotations
    static let nStation = "N Station"
    static let nameStation = "Nom Station"
    static let adress = "Ad Station"
    static let adressStation = "Adresse Station"
    static let numberOutlets = "Nbre Pdc"
    static let numberOutletsLong = "Nombres Prises"
    static let powerMax = "Puiss Max"
    static let powerMaxLong = "Puissance Max"
    static let kW = "kW"
    static let free = "gratuit"
    
    // MARK: Others
    static let empty = ""
    
    // MARK: URL / PARAMETERS
    static let https = "https"
    static let host = "public.opendatasoft.com"
    static let path = "/api/records/1.0/search"
    
    // Parameters Name
    static let dataset = ("dataset", "fichier-consolide-des-bornes-de-recharge-pour-vehicules-electriques-irve")
    static let lang = ("lang", "fr")
    static let rows = ("rows", "1000")
    static let numberOutletsFacet = ("facet", "nbre_pdc")
    static let powerFacet = ("facet", "puiss_max")
    static let accessibilityFacet = ("facet", "accessibilite")
    static let nameStationFacet = ("facet", "n_station")
    static let geofilterDistance = "geofilter.distance"
    
    
    // User Position
    static let positionNotDetected = "Position non detectée"
    static let activateLocation = "Activer la localisation"
    static let getAllAnnotationInFrance = "Récuperer toutes les bornes"
}
