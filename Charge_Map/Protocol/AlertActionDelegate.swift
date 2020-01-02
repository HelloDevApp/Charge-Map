//
//  AlertActionDelegate.swift
//  Charge_Map
//
//  Created by Macbook pro on 30/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

protocol AlertActionDelegate {}

extension AlertActionDelegate {
    
    func presentAlert(controller: UIViewController, title: String, message: String?, actions: [UIAlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
            controller.present(alertController, animated: true)
        }
    }
}
