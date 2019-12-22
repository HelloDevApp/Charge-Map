//
//  TableViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 21/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    var datas: Datas!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func addGradientToView(cell: CustomTableViewCell, layer: CAGradientLayer, view: UIView, first: UIColor, second: UIColor, third: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [first.cgColor, second.cgColor, third.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        gradientLayer.frame = cell.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func fillCell(for cell: CustomTableViewCell, with annotations: [CustomAnnotation], indexPath: IndexPath) {
        
        let annotation = annotations[indexPath.row]
        
            if let fields = annotation.field {
                
                if let powerMax = fields.puiss_max {
                    cell.powerLabel.text = "\(powerMax)"
                }
                if let adress = fields.ad_station {
                    cell.adressLabel.text = "\(adress)"
                }
                if let freeOrPaid = fields.acces_recharge {
                    cell.freeOrPaidLabel.text = "\(freeOrPaid)"
                }
                if let outletType = fields.type_prise {
                    cell.outletTypeLabel.text = "\(outletType)"
                }
                if let numberOutlet = fields.nbre_pdc {
                    cell.numberOutletLabel.text = "\(numberOutlet)"
                }
                if let terminalNameStation = fields.n_station {
                    cell.terminalNameLabel.text = "\(terminalNameStation)"
                }
                cell.distanceLabel.text = "Valeur non correct"
        }
    }

}

extension TableViewController: UITableViewDelegate {
    
}


extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        return datas.annotations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let annotations = datas.annotations
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell {
            fillCell(for: cell, with: annotations, indexPath: indexPath)
            let backgroundView = cell.contentView
                if indexPath.row % 2 == 0 {
                    addGradientToView(cell: cell, layer: cell.gradient, view: backgroundView, first: #colorLiteral(red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1), second: #colorLiteral(red: 0.1304242228, green: 0.1291453451, blue: 0.1290467195, alpha: 1), third: #colorLiteral(red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1))
                } else {
                    addGradientToView(cell: cell, layer: cell.gradient, view: backgroundView, first: #colorLiteral(red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1), second: #colorLiteral(red: 0.1304242228, green: 0.1291453451, blue: 0.1290467195, alpha: 1), third: #colorLiteral(red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1))
                }
                return cell
        }
        return UITableViewCell()
    }
}
