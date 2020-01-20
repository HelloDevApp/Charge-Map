//
//  CustomCollectionViewCell.swift
//  Charge_Map
//
//  Created by Macbook pro on 27/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var customLabelTop: UILabel!
    @IBOutlet weak var customLabelBottom: UILabel!
    
    
    func setup(messageTop: String, messageBottom: String) {
        customLabelBottom.numberOfLines = 0
        customLabelBottom.minimumScaleFactor = 0.5
        customLabelTop.text = messageTop
        customLabelBottom.text = messageBottom
        customLabelTop.textAlignment = .center
        customLabelBottom.font = .boldSystemFont(ofSize: 20)
    }
    
    override func prepareForReuse() {
        customLabelTop.text = nil
        customLabelBottom.text = nil  
    }
    
    
}
