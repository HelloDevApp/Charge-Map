//
//  CoreDataManager.swift
//  Charge_Map
//
//  Created by Macbook pro on 30/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var favoritesStation = [Station]()
    
    let container = NSPersistentContainer(name: "Charge_Map")
    
    private lazy var persistentContainer: NSPersistentContainer = {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Init for Test
    init(inMemoryType: Bool = false) {
        if inMemoryType {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
        }
    }
    
    // MARK: - Methods (CRUD)
    func create(station_: CustomAnnotation) {
        let station = Station(context: viewContext)
        station.latitude = station_.coordinate.latitude
        station.longitude = station_.coordinate.longitude
        station.accessibility = station_.field?.accessibilite
        station.adress = station_.field?.ad_station
        station.chargeAccess = station_.field?.acces_recharge
        station.name = station_.field?.n_station
        station.numberOutlets = Int16(station_.field?.nbre_pdc ?? 0)
        station.outletType = station_.field?.type_prise
        station.powerMax = station_.field?.puiss_max ?? 0
        station.updateDate = station_.field?.date_maj
        
        viewContext.insert(station)
        update()
    }
    
    func read() -> [Station] {
        let request: NSFetchRequest<Station> = Station.fetchRequest()
        
        do {
            favoritesStation = try viewContext.fetch(request).reversed()
            //                favoritesStation = try viewContext.fetch(request).reversed()
            print("retrieve Favorites...")
            return favoritesStation
        }
        catch {
            print("no fav")
            return [Station]()
        }
    }
    
    func update() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        print("object has been saved in the context.")
    }
    
    func delete(station_: Station) {
        viewContext.delete(station_)
        favoritesStation = read()
        update()
    }
}
