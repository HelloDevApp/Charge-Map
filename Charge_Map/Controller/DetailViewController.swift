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
            if indexPath.row % 2 == 0 {
                view.firstColor = #colorLiteral(red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1)
                view.secondColor = #colorLiteral(red: 0.1304242228, green: 0.1291453451, blue: 0.1290467195, alpha: 1)
                view.thirdColor = #colorLiteral(red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1)
            } else {
                view.firstColor = #colorLiteral(red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1)
                view.secondColor = #colorLiteral(red: 0.1304242228, green: 0.1291453451, blue: 0.1290467195, alpha: 1)
                view.thirdColor = #colorLiteral(red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? CustomCollectionViewCell else {
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
        if labelWithoutUnderscore == "N Station" {
            collectionCell.setup(messageTop: "Nom Station", messageBottom: "\(arrayValue[indexPath.row])")
        } else if labelWithoutUnderscore == "Ad Station" {
            adressLabel.text = "\(arrayValue[indexPath.row].capitalized)"
            collectionCell.setup(messageTop: "Adresse Station", messageBottom: "\(arrayValue[indexPath.row])")
        } else if labelWithoutUnderscore == "Nbre Pdc" {
            collectionCell.setup(messageTop: "Nombres Prises", messageBottom: "\(arrayValue[indexPath.row])")
        } else if labelWithoutUnderscore == "Puiss Max" {
            collectionCell.setup(messageTop: "Puissance Max", messageBottom: "\(arrayValue[indexPath.row]) kW")
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
