//
//  DetailViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 21/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, SettingsDelegate {
    
    // This array is required to scan the fields and automate the assignment of values to the label in the cells.
    private var coreDataManager: CoreDataManager {
        guard let cdm = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager else { return CoreDataManager() }
        return cdm
    }
    var fields = [Fields]()
    var apiHelper: ApiHelper?
    var annotationManager: AnnotationManager!
    
    
    @IBOutlet var gradientView: GradientView!
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theme = checkThemeColor(theme: Datas.choosenTheme.rawValue)
        navigationController?.navigationBar.isHidden = false
        guard let firstColor = theme?.firstColor else { return }
        navigationController?.navigationBar.barTintColor = firstColor
        
        
        if let view = view as? GradientView {
            applyTheme(theme: Datas.choosenTheme, view: view, navigationBar: navigationController?.navigationBar, reverse: false)
        }
        
    }
    
    @IBAction func addStationInFavorites(_ sender: UIBarButtonItem) {
        guard let annotationSelected = annotationManager.annotationSelected else { return }
        coreDataManager.create(station_: annotationSelected)
    }
    
    @IBAction func goToMapsAppAction() {
        guard let annotationSelected = annotationManager.annotationSelected else { return }
        goToMapsApp(destinationCoordinate: annotationSelected.coordinate)
    }
    
    func goToMapsApp(destinationCoordinate: CLLocationCoordinate2D) {
        
        guard let url = annotationManager.returnUrlRedirection(destinationCoordinate: destinationCoordinate) else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}


// MARK: - Collection View Settings
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fields[0].countProperties()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 1.1
        let height = collectionView.frame.height / 3.45
        
        let size = CGSize(width: width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let view = cell.contentView as? GradientView {
            if indexPath.row % 2 == .zero {
                applyTheme(theme: Datas.choosenTheme, view: view, navigationBar: navigationController?.navigationBar, reverse: false)
                
            } else {
                applyTheme(theme: Datas.choosenTheme, view: view, navigationBar: navigationController?.navigationBar, reverse: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Word.customCell, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let apiHelper = apiHelper else { return collectionCell }
        
        let arrayResult = apiHelper.convert(field: fields[0], annotationManager: annotationManager)
        guard let arrayLabel = arrayResult[0] as? [String], let arrayValue = arrayResult[1] as? [String] else { return collectionCell }
        
        returnCellForRow(arrayLabel: arrayLabel, arrayValue: arrayValue, collectionCell: collectionCell, indexPath: indexPath)
        
        return collectionCell
    }
    
    // Allows to replace the abbreviations returned by the api with normal words and assign values to the cell
    func returnCellForRow(arrayLabel: [String], arrayValue: [String], collectionCell: CustomCollectionViewCell, indexPath: IndexPath) {
        let labelWithoutUnderscore = arrayLabel[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
        let value = "\(arrayValue[indexPath.row])"
        if labelWithoutUnderscore == Word.nStation {
            collectionCell.setup(messageTop: Word.nameStation, messageBottom: value)
        } else if labelWithoutUnderscore == Word.adress {
            adressLabel.text = value.capitalized
            collectionCell.setup(messageTop: Word.adressStation, messageBottom: value)
        } else if labelWithoutUnderscore == Word.numberOutlets {
            collectionCell.setup(messageTop: Word.numberOutletsLong, messageBottom: value)
        } else if labelWithoutUnderscore == Word.powerMax {
            collectionCell.setup(messageTop: Word.powerMaxLong, messageBottom: value + Word.kW)
        } else {
            collectionCell.setup(messageTop: "\(labelWithoutUnderscore)", messageBottom: value)
        }
    }
}
