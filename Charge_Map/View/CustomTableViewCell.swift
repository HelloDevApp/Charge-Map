//
//  CustomTableViewCell.swift
//  Charge_Map
//
//  Created by Macbook pro on 21/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var gradient = CAGradientLayer()
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var terminalNameLabel: UILabel!
    
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var powerLabel: UILabel!
    
    @IBOutlet weak var freeOrPaidLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var outletTypeLabel: UILabel!
    
    @IBOutlet weak var numberOutletLabel: UILabel!
    
    override class func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        
//        terminalNameLabel = nil
//        adressLabel = nil
//        powerLabel = nil
//        freeOrPaidLabel = nil
//        distanceLabel = nil
//        outletTypeLabel = nil
//        numberOutletLabel = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradient = contentView.layer.sublayers?[0] as? CAGradientLayer {
            gradient.frame = CGRect(x: 0, y: stackView.frame.minY - 5, width: bounds.width, height: bounds.height)
        }
    }
}
