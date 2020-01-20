//
//  FavoriteTableViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 03/01/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UIViewController {
    
    var coreDataManager: CoreDataManager {
        guard let cdm = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager else { return CoreDataManager() }
        return cdm
    }
    
    var annotationManager: AnnotationManager? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
}

extension FavoriteTableViewController: UITableViewDelegate, UITableViewDataSource, CustomTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let _ = coreDataManager.read()
        return coreDataManager.read().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell {
            let contentView = cell.contentView
            fillCell(for: cell, with: coreDataManager.favoritesStation, indexPath: indexPath, annotationManager: annotationManager)
            
            if indexPath.row % 2 == 0 {
                addGradientToView(theme: Datas.choosenTheme, view: contentView, even: true)
            } else {
                addGradientToView(theme: Datas.choosenTheme, view: contentView, even: false)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    
}

