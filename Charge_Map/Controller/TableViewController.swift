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
    
    func addGradientToView(view: UIView, even: Bool) {
        
        let gradientLayer = CAGradientLayer()
        let lightRedColor = Datas.lightRedColor
        let darkRedColor = Datas.darkRedColor
        
        let first = UIColor(red: CGFloat(darkRedColor.red), green: CGFloat(darkRedColor.green), blue: CGFloat(darkRedColor.blue), alpha: 1.0)
        
        let second = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        
        let third = UIColor(red: CGFloat(lightRedColor.red), green: CGFloat(lightRedColor.green), blue: CGFloat(lightRedColor.blue), alpha: 1.0)
        
        if even == false {
            gradientLayer.colors = [first.cgColor, second.cgColor, third.cgColor]
        } else {
            gradientLayer.colors = [third.cgColor, second.cgColor, first.cgColor]
        }
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: Word.customCell, for: indexPath) as? CustomTableViewCell {
            fillCell(for: cell, with: annotations, indexPath: indexPath)
            let contentView = cell.contentView
                if indexPath.row % 2 == 0 {
                    addGradientToView(view: contentView, even: true)
                } else {
                    addGradientToView(view: contentView, even: false)
                }
                return cell
        }
        return UITableViewCell()
    }
}
