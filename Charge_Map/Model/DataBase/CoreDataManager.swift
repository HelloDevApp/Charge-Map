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
    var currentTheme = Datas.choosenTheme.rawValue
    
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
    func create(station: CustomAnnotation) {
        let station_ = Station(context: viewContext)
        station_.latitude = station.coordinate.latitude
        station_.longitude = station.coordinate.longitude
        station_.accessibility = station.field?.accessibilite
        station_.adress = station.field?.ad_station
        station_.chargeAccess = station.field?.acces_recharge
        station_.name = station.field?.n_station
        station_.numberOutlets = Int16(station.field?.nbre_pdc ?? 0)
        station_.outletType = station.field?.type_prise
        station_.powerMax = station.field?.puiss_max ?? 0
        station_.updateDate = station.field?.date_maj
        
        viewContext.insert(station_)
        update()
    }
    
    func read() -> [Station] {
        let request: NSFetchRequest<Station> = Station.fetchRequest()
        
        do {
            favoritesStation = try viewContext.fetch(request).reversed()
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
