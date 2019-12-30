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
 
    var annotationManager: AnnotationManager!
    
    private var coreDataManager: CoreDataManager {
        guard let cdm = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager else { return CoreDataManager() }
        return cdm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}


// MARK: - Table View Settings
extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        return annotationManager.annotations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let annotations = annotationManager.annotations
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Word.customCell, for: indexPath) as? CustomTableViewCell {
            let contentView = cell.contentView
            
            fillCell(for: cell, with: annotations, indexPath: indexPath)
            
            if indexPath.row % 2 == 0 {
                addGradientToView(theme: Datas.choosenTheme, view: contentView, even: true)
            } else {
                addGradientToView(theme: Datas.choosenTheme, view: contentView, even: false)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func fillCell(for cell: CustomTableViewCell, with annotations: [CustomAnnotation], indexPath: IndexPath) {
        let annotation = annotations[indexPath.row]
        fillTextLabel(field: annotation.field, cell: cell, indexPath: indexPath)
    }
    
    func fillTextLabel(field: Fields?, cell: CustomTableViewCell, indexPath: IndexPath) {
        
        if let field = field {
            if let powerMax = field.puiss_max {
                cell.powerLabel.text = "\(powerMax)"
            }
            if let adress = field.ad_station {
                cell.adressLabel.text = "\(adress)"
            }
            if let freeOrPaid = field.acces_recharge {
                cell.freeOrPaidLabel.text = "\(freeOrPaid)"
            }
            if let outletType = field.type_prise {
                cell.outletTypeLabel.text = "\(outletType)"
            }
            if let numberOutlet = field.nbre_pdc {
                cell.numberOutletLabel.text = "\(numberOutlet)"
            }
            if let terminalNameStation = field.n_station {
                cell.terminalNameLabel.text = "\(terminalNameStation)"
            }
            let coordinateUser = Datas.coordinateUser
            let coordinateTerminal = annotationManager.annotations[indexPath.row].coordinate
            let locationUser = CLLocation(latitude: coordinateUser.latitude, longitude: coordinateUser.longitude)
            let locationTerminal = CLLocation(latitude: coordinateTerminal.latitude, longitude: coordinateTerminal.longitude)
            cell.distanceLabel.text = String(format: "%.01f", locationUser.distance(from: locationTerminal) / 1000)
            cell.distanceLabel.text?.append(Word.kilometers)
            
        }
    }
}


// MARK: - GradientView
extension TableViewController: SettingsDelegate {
    
    func addGradientToView(theme: Theme, view: UIView, even: Bool) {
        
        let gradientLayer = CAGradientLayer()
        
        let theme = checkThemeColor(theme: theme.rawValue)
        
        guard let first = theme?.firstColor,
            let second = theme?.secondColor,
            let third = theme?.thirdColor else { return }
        
        if even == false {
            gradientLayer.colors = [first.cgColor, second.cgColor, third.cgColor]
        } else {
            gradientLayer.colors = [third.cgColor, second.cgColor, first.cgColor]
        }
        
        gradientLayer.startPoint = Datas.startPointGradient
        gradientLayer.endPoint = Datas.endPointGradient
        
        view.layer.insertSublayer(gradientLayer, at: .zero
        )
    }
}

// MARK: TableView Delegate
extension TableViewController: UITableViewDelegate, AlertActionDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // We ask if the user wants to save the station or go to destination
        
        // redirecting action
        let redirectingAction = UIAlertAction(title: Word.getDirection, style: .default) { (_) in
            
        }
        
        // safeguard action
        let addToFavoritesAction = UIAlertAction(title: Word.addingStationInFav, style: .default) { (_) in
            self.coreDataManager.create(station_: self.annotationManager.annotations[indexPath.row])
        }
        
        // cancel action
        let cancelAction = UIAlertAction(title: Word.back, style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        presentAlert(controller: self, title: Word.whatToDo, message: nil, actions: [addToFavoritesAction, redirectingAction, cancelAction])
    }
    
}


protocol FavoriteDelegate {}

extension FavoriteDelegate {
    func addToFavorite(annotation: CustomAnnotation) {
    }
}
