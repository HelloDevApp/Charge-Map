//
//  TableViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 21/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
 
    var annotationManager: AnnotationManager!
    
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
                addGradientToView(view: contentView, even: true)
            } else {
                addGradientToView(view: contentView, even: false)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func fillCell(for cell: CustomTableViewCell, with annotations: [CustomAnnotation], indexPath: IndexPath) {
        let annotation = annotations[indexPath.row]
        fillTextLabel(field: annotation.field, cell: cell)
    }
    
    func fillTextLabel(field: Fields?, cell: CustomTableViewCell) {
        
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
            cell.distanceLabel.text = "Valeur non correct"
        }
    }
}


// MARK: - GradientView
extension TableViewController {
    
    func addGradientToView(view: UIView, even: Bool) {
        
        let gradientLayer = CAGradientLayer()
        let datas = Datas()
        let light = datas.lightRedColor
        let dark = datas.darkRedColor
        
        
        let first = UIColor(red: CGFloat(dark.red), green: CGFloat(dark.green), blue: CGFloat(dark.blue), alpha: datas.alpha)
        let second = UIColor(red: .zero, green: .zero, blue: .zero, alpha: datas.alpha)
        let third = UIColor(red: CGFloat(light.red), green: CGFloat(light.green), blue: CGFloat(light.blue), alpha: datas.alpha)
        
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
