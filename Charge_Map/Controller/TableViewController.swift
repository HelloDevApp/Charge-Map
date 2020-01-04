//
//  TableViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 21/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var annotationManager: AnnotationManager? = nil
    
    private var coreDataManager: CoreDataManager {
        guard let cdm = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager else { return CoreDataManager() }
        return cdm
    }
    
    // MARK: - LifeCycle METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}


// MARK: - Table View Data Source
extension TableViewController: UITableViewDataSource, CustomTableViewCellDelegate {
    
    
    
    func checkIfAnnotationIsInFavorites(cell: CustomTableViewCell, annotationSelected: CustomAnnotation) {
        for station in coreDataManager.favoritesStation {
            if station.latitude == annotationSelected.field?.coordonnees?.first,
                station.longitude == annotationSelected.field?.coordonnees?.last,
                station.name == annotationSelected.field?.n_station {
                cell.favoriteImageView.isHidden = false
                return
            }
        }
        cell.favoriteImageView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        return annotationManager?.annotations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let annotations = annotationManager?.annotations {
            
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: Word.customCell, for: indexPath) as? CustomTableViewCell {
                let contentView = cell.contentView
                
                fillCell(for: cell, with: annotations, indexPath: indexPath, annotationManager: annotationManager)
                checkIfAnnotationIsInFavorites(cell: cell, annotationSelected: annotations[indexPath.row])
                
                if indexPath.row % 2 == 0 {
                    addGradientToView(theme: Datas.choosenTheme, view: contentView, even: true)
                } else {
                    addGradientToView(theme: Datas.choosenTheme, view: contentView, even: false)
                }
                
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: TableView Delegate
extension TableViewController: UITableViewDelegate, AlertActionDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // create alert actions
        let redirectingAlertAction = createRedicrectingAlertAction(indexPath: indexPath)
        let addToFavoritesAlertAction = createAddToFavoritesAlertAction(indexPath: indexPath)
        let cancelAlertAction = createCancelAlertAction()
        
        presentAlert(controller: self, title: Word.whatToDo, message: nil, actions: [addToFavoritesAlertAction, redirectingAlertAction, cancelAlertAction])
    }
    
    // MARK: - Create Alert Action Methods
    private func createRedicrectingAlertAction(indexPath: IndexPath) -> UIAlertAction {
        // redirecting action
        let redirectingAlertAction = UIAlertAction(title: Word.getDirection, style: .default) { (_) in
            guard let coordinate = self.annotationManager?.annotations[indexPath.row].coordinate else { return }
           
            self.annotationManager?.getDirection(destinationCoordinate: coordinate)
        }
        return redirectingAlertAction
    }
    
    private func createAddToFavoritesAlertAction(indexPath: IndexPath) -> UIAlertAction {
        // safeguard action
        let addToFavoritesAlertAction = UIAlertAction(title: Word.addingStationInFav, style: .default) { (_) in
            guard let annotation = self.annotationManager?.annotations[indexPath.row] else { return }
            let favoriteManager = FavoriteManager()
            let _ = favoriteManager.saveStation(annotation: annotation, coreDataManager: self.coreDataManager)
            guard let annotationManager = self.annotationManager else { return }
            self.checkIfAnnotationIsInFavorites(cell: self.tableView.cellForRow(at: indexPath) as! CustomTableViewCell, annotationSelected: annotationManager.annotations[indexPath.row])
        }
        return addToFavoritesAlertAction
    }
    
    private func createCancelAlertAction() -> UIAlertAction {
        // cancel action
        let cancelAlertAction = UIAlertAction(title: Word.back, style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        return cancelAlertAction
    }
    
}
