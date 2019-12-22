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
    
    var fields = [Fields]()
    var apiHelper: API_Helper?
    var annotationSelected: CustomAnnotation?
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToDestinationAction() {
        goToDestination(destinationCoordinate: annotationSelected!.coordinate)
    }
    
    func goToDestination(destinationCoordinate: CLLocationCoordinate2D) {
        
        let parameters: [URLQueryItem] = [
            URLQueryItem(name: "saddr", value: "\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)"),
            URLQueryItem(name: "daddr", value: "\(48.0909),\(2.0302)"),
            URLQueryItem(name: "dirflg", value: "d")]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host   = "maps.apple.com"
        //        url.path   = "/saddr/records/1.0/search"
        urlComponents.queryItems = parameters
        
        guard let url = urlComponents.url else { return }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
        UIApplication.shared.openURL(url)
        }
        
    }
}


// MARK: - Collection View Settings
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fields[0].countProperties()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let view = cell.contentView as? GradientView {
            let lightRedColor = Datas.lightRedColor
            let darkRedColor = Datas.darkRedColor
            if indexPath.row % 2 == 0 {
                // 1 light
                view.firstColor = UIColor(red: CGFloat(lightRedColor.red), green: CGFloat(lightRedColor.green), blue: CGFloat(lightRedColor.blue), alpha: 1.0)
                // 2 black
                view.secondColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                // 3 dark
                view.thirdColor = UIColor(red: CGFloat(darkRedColor.red), green: CGFloat(darkRedColor.green), blue: CGFloat(darkRedColor.blue), alpha: 1.0)
                
            } else {
                // 1 dark
                view.firstColor = UIColor(red: CGFloat(darkRedColor.red), green: CGFloat(darkRedColor.green), blue: CGFloat(darkRedColor.blue), alpha: 1.0)
                // 2 black
                view.secondColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                // 3 light
                view.thirdColor = UIColor(red: CGFloat(lightRedColor.red), green: CGFloat(lightRedColor.green), blue: CGFloat(lightRedColor.blue), alpha: 1.0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Word.customCell, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let apiHelper = apiHelper else { return collectionCell }
        
        let arrayResult = apiHelper.convert(field: fields[0])
        guard let arrayLabel = arrayResult[0] as? [String], let arrayValue = arrayResult[1] as? [String] else { return collectionCell }
        
        returnCellForRow(arrayLabel: arrayLabel, arrayValue: arrayValue, collectionCell: collectionCell, indexPath: indexPath)
        
        return collectionCell
    }
    
    func returnCellForRow(arrayLabel: [String], arrayValue: [String], collectionCell: CustomCollectionViewCell, indexPath: IndexPath) {
        let labelWithoutUnderscore = arrayLabel[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
        if labelWithoutUnderscore == Word.nStation {
            collectionCell.setup(messageTop: Word.nameStation, messageBottom: "\(arrayValue[indexPath.row])")
        } else if labelWithoutUnderscore == Word.adress {
            adressLabel.text = "\(arrayValue[indexPath.row].capitalized)"
            collectionCell.setup(messageTop: Word.adressStation, messageBottom: "\(arrayValue[indexPath.row])")
        } else if labelWithoutUnderscore == Word.numberOutlets {
            collectionCell.setup(messageTop: Word.numberOutletsLong, messageBottom: "\(arrayValue[indexPath.row])")
        } else if labelWithoutUnderscore == Word.powerMax {
            collectionCell.setup(messageTop: Word.powerMaxLong, messageBottom: "\(arrayValue[indexPath.row]) \(Word.kW)")
        } else {
            collectionCell.setup(messageTop: "\(labelWithoutUnderscore)", messageBottom: "\(arrayValue[indexPath.row])") // ligne original
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 1.1
        let height = collectionView.frame.height / 3.45
        
        let size = CGSize(width: width, height: height)
        return size
    }
}
