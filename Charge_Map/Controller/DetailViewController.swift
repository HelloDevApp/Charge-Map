//
//  DetailViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 21/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var fields = [Fields]()
    var apiHelper: API_Helper?
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.selectRow(Datas.powerCar.count / 2, inComponent: 0, animated: false)
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
                view.firstColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                view.secondColor = .darkText
                view.thirdColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            } else {
                view.firstColor = #colorLiteral(red: 0.01882067508, green: 0.07149865637, blue: 0.4949400907, alpha: 1)
                view.secondColor = .darkText
                view.thirdColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
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
        
        switchLabelChild(labelChild: arrayLabel[indexPath.row], valueChild: arrayValue[indexPath.row], collectionCell: collectionCell)
        
        return collectionCell
    }
    
    func switchLabelChild(labelChild: String, valueChild: String, collectionCell: CustomCollectionViewCell) {
        switch labelChild {
        case "ad_station":
            adressLabel.text = valueChild
        case "n_station":
            collectionCell.customLabelTop.text = "Nom Station"
        default:
            let labelWithoutUnderscore = labelChild.replacingOccurrences(of: "_", with: " ").capitalized
            collectionCell.setup(messageTop: "\(labelWithoutUnderscore)", messageBottom: "\(valueChild)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 1.1
        let height = collectionView.frame.height / 2.15
        
        let size = CGSize(width: width, height: height)
        return size
    }
}


// MARK: - PickerView Settings
extension DetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Datas.powerCar.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString: NSAttributedString = NSAttributedString(string: "\(Datas.powerCar[row]) khw", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white]) //NSAttributedString.Key.backgroundColor : UIColor.black])
        return attributedString
    }
    
}
