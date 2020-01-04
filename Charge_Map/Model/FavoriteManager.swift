//
//  FavoriteManager.swift
//  Charge_Map
//
//  Created by Macbook pro on 02/01/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import Foundation

class FavoriteManager: AlertActionDelegate {
    
    func saveStation(annotation: CustomAnnotation, coreDataManager: CoreDataManager) -> (okToSaved: Bool, titleAction: String, messageAction: String) {
        var canSave = true
        let lat = annotation.coordinate.latitude
        let long = annotation.coordinate.longitude
        
        for favoriteStation in coreDataManager.read() {
            if favoriteStation.latitude != lat && favoriteStation.longitude != long {
                canSave = true
            } else {
                canSave = false
                break
            }
        }
        
        if switchCanSaveToreturnAlertDetails(canSave: canSave).okToSaved {
            coreDataManager.create(station: annotation)
            print("station ajouté")
        } else {
            for station in coreDataManager.read() {
                if station.latitude == annotation.coordinate.latitude,
                    station.longitude == annotation.coordinate.longitude,
                    station.name == annotation.field?.n_station {
                    coreDataManager.delete(station_: station)
                    print("station supprimé")
                    break
                }
            }
        }
        
        return switchCanSaveToreturnAlertDetails(canSave: canSave)
    }
    
    private func switchCanSaveToreturnAlertDetails(canSave: Bool) -> (okToSaved: Bool, titleAction: String, messageAction: String) {
        
        switch canSave {
            case true:
                return (true, "OK", "Station de charge sauvegardé dans vos favoris")
            case false:
            return (false, "Oups", "Cette Station de charge est deja dans vos favoris")
        }
    }
}

