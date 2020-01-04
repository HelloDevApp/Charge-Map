//
//  CustomTableViewCellDelegate.swift
//  Charge_Map
//
//  Created by Macbook pro on 03/01/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import CoreLocation
import UIKit

protocol CustomTableViewCellDelegate: SettingsDelegate {}

extension CustomTableViewCellDelegate {
    
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
    
    
    func fillCell(for cell: CustomTableViewCell, with annotations: [Any], indexPath: IndexPath, annotationManager: AnnotationManager?) {
        
        let annotation = annotations[indexPath.row]
        
        if let annotation = annotation as? CustomAnnotation {
            fillTextOfLabels(field: annotation.field, cell: cell, indexPath: indexPath, annotationManager: annotationManager)
        }
        
        if let annotation = annotation as? Station {
            
            let coordinate = [annotation.latitude, annotation.longitude]
            
            let fields = Fields(type_prise: annotation.outletType, ad_station: annotation.adress, date_maj: annotation.updateDate, accessibilite: annotation.accessibility, n_station: annotation.name, coordonnees: coordinate, acces_recharge: annotation.chargeAccess, nbre_pdc: Int(annotation.numberOutlets), puiss_max: annotation.powerMax)
            
            fillTextOfLabels(field: fields, cell: cell, indexPath: indexPath, annotationManager: annotationManager)
        }
    }
    
    private func fillTextOfLabels(field: Fields?, cell: CustomTableViewCell, indexPath: IndexPath, annotationManager: AnnotationManager?) {
        
        if let field = field {
            updatePowerLabel(field, cell)
            updateAdressLabel(field, cell)
            updateFreeOrPaidLabel(field, cell)
            updateOutletTypeLabel(field, cell)
            updateNumberOutletLabel(field, cell)
            updateTerminalNameLabel(field, cell)
            guard let annotationManager = annotationManager else { return }
            updateDistanceLabel(annotationManager: annotationManager, cell: cell, indexPath: indexPath)
        }
    }
    
    
    private func updatePowerLabel(_ field: Fields, _ cell: CustomTableViewCell) {
        if let powerMax = field.puiss_max {
            cell.powerLabel.text = "\(powerMax)"
        }
    }
    
    private func updateAdressLabel(_ field: Fields, _ cell: CustomTableViewCell) {
        if let adress = field.ad_station {
            cell.adressLabel.text = "\(adress)"
        }
    }
    
    private func updateFreeOrPaidLabel(_ field: Fields, _ cell: CustomTableViewCell) {
        if let freeOrPaid = field.acces_recharge {
            cell.freeOrPaidLabel.text = "\(freeOrPaid)"
        }
    }
    
    private func updateOutletTypeLabel(_ field: Fields, _ cell: CustomTableViewCell) {
        if let outletType = field.type_prise {
            cell.outletTypeLabel.text = "\(outletType)"
        }
    }
    
    private func updateNumberOutletLabel(_ field: Fields, _ cell: CustomTableViewCell) {
        if let numberOutlet = field.nbre_pdc {
            cell.numberOutletLabel.text = "\(numberOutlet)"
        }
    }
    
    private func updateTerminalNameLabel(_ field: Fields, _ cell: CustomTableViewCell) {
        if let terminalNameStation = field.n_station {
            cell.terminalNameLabel.text = "\(terminalNameStation)"
        }
    }
    
    private func updateDistanceLabel(annotationManager: AnnotationManager, cell: CustomTableViewCell, indexPath: IndexPath) {
        let coordinateUser = Datas.coordinateUser
        let coordinateTerminal = annotationManager.annotations[indexPath.row].coordinate
        let locationUser = CLLocation(latitude: coordinateUser.latitude, longitude: coordinateUser.longitude)
        let locationTerminal = CLLocation(latitude: coordinateTerminal.latitude, longitude: coordinateTerminal.longitude)
        cell.distanceLabel.text = String(format: "%.01f", locationUser.distance(from: locationTerminal) / 1000)
        cell.distanceLabel.text?.append(Word.kilometers)
    }
    
    
}
