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
    static let back = "Retour"
    static let whatToDo = "Que voulez vous faire"
    static let kilometers = "km"
    
    // MARK: URL API / PARAMETERS
    static let http = "http"
    static let https = "https"
    static let hostAppleMap = "maps.apple.com"
    static let hostApi = "public.opendatasoft.com"
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
    
    // Url that redirects to the settings page
    static let urlSettingsPages = "App-Prefs:root=Privacy&path=LOCATION"
    
    // Direction, Direction URL
    static let getDirection = "Accéder à l'itinéraire"
    static let sourceAdress = "saddr"
    static let destinationAdress = "daddr"
    static let directionFlg = (key: "dirflg", value: "d")
    
    // Favorite
    static let addingStationInFav = "Ajouter la borne aux favoris"
}
