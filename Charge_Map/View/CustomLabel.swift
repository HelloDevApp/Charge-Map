//
//  CustomLabel.swift
//  Charge_Map
//
//  Created by Macbook pro on 23/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // setting up of the custom label
    func setup() {
        self.backgroundColor = UIColor.clear
        self.textColor = .white
        self.textAlignment = .center
    }
    
}
