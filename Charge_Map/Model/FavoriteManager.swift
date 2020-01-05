//
//  FavoriteManager.swift
//  Charge_Map
//
//  Created by Macbook pro on 02/01/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import Foundation

class FavoriteManager: AlertActionDelegate {
    
    func saveStation(annotation: CustomAnnotation, coreDataManager: CoreDataManager) -> Bool {
        
        let isSaved = saveOrDeleteStation(coreDataManager, annotation)
        
        if isSaved {
            return true
        } else {
            return false
        }
        
    }
    
    func checkIfAnnotationIsInFavorites(annotationSelected: CustomAnnotation, coreDataManager: CoreDataManager) -> Bool {
        for station in coreDataManager.favoritesStation {
            if station.latitude == annotationSelected.field?.coordonnees?.first,
                station.longitude == annotationSelected.field?.coordonnees?.last,
                station.name == annotationSelected.field?.n_station {
                return true
            }
        }
        return false
    }
    
    private func saveOrDeleteStation(_ coreDataManager: CoreDataManager, _ annotation: CustomAnnotation) -> Bool {
        if checkIfAnnotationIsInFavorites(annotationSelected: annotation, coreDataManager: coreDataManager) == false {
            coreDataManager.create(station: annotation)
            print("station ajouté")
            return true
        } else {
            deleteStationIfItIsAlreadyInFavorites(coreDataManager, annotation)
            print("station supprimé")
            return false
        }
    }
    
    private func deleteStationIfItIsAlreadyInFavorites(_ coreDataManager: CoreDataManager, _ annotation: CustomAnnotation) {
        for station in coreDataManager.read() {
            if station.latitude == annotation.coordinate.latitude,
                station.longitude == annotation.coordinate.longitude,
                station.name == annotation.field?.n_station {
                
                coreDataManager.delete(station_: station)
                
                break
            }
        }
    }
}

