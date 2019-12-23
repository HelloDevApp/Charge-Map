//
//  DetailViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 21/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    // This array is required to scan the fields and automate the assignment of values to the label in the cells.
    var fields = [Fields]()
    var apiHelper: ApiHelper?
    var annotationManager: AnnotationManager!
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let datas = Datas()
            let light = datas.lightRedColor
            let dark = datas.darkRedColor
            if indexPath.row % 2 == .zero {
                // 1 light, 2 black, 3 dark
                view.firstColor = UIColor(red: CGFloat(light.red), green: CGFloat(light.green), blue: CGFloat(light.blue), alpha: datas.alpha)
                view.secondColor = UIColor(red: .zero, green: .zero, blue: .zero, alpha: datas.alpha)
                view.thirdColor = UIColor(red: CGFloat(dark.red), green: CGFloat(dark.green), blue: CGFloat(dark.blue), alpha: datas.alpha)
                
            } else {
                // 1 dark , 2 black , 3 light
                view.firstColor = UIColor(red: CGFloat(dark.red), green: CGFloat(dark.green), blue: CGFloat(dark.blue), alpha: datas.alpha)
                view.secondColor = UIColor(red: .zero, green: .zero, blue: .zero, alpha: datas.alpha)
                view.thirdColor = UIColor(red: CGFloat(light.red), green: CGFloat(light.green), blue: CGFloat(light.blue), alpha: datas.alpha)
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
