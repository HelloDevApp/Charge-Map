//
//  SettingsDelegate.swift
//  Charge_Map
//
//  Created by Macbook pro on 27/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

enum Theme: String {
    
    case blackAndWhite = "blackAndWhite"
    case classic = "classic"
    case natural = "natural"
    case metal = "metal"
    case design = "design"
    case ocean = "ocean"
    case retro = "retro"
    case confort = "confort"
    case galaxy = "galaxy"
}

protocol SettingsDelegate {}

extension SettingsDelegate {
    
    private func convertDatasColorToUIColor(datasColor: (red: Double, green:
        Double, blue: Double , alpha: Int)) -> UIColor {
        let color = UIColor(red: CGFloat(datasColor.red), green: CGFloat(datasColor.green), blue: CGFloat(datasColor.blue), alpha: CGFloat(datasColor.alpha))
        return color
    }
    
    func applyTheme(theme: Theme, view: UIView?, navigationBar: UINavigationBar?, reverse: Bool) {
        
        let themeColors = checkThemeColor(theme: theme.rawValue)
        
        guard let firstColor = themeColors?.firstColor,
              let secondColor = themeColors?.secondColor,
              let thirdColor = themeColors?.thirdColor else { return }
        
        Datas.choosenTheme = theme
        
        navigationBar?.barTintColor = secondColor
        navigationBar?.tintColor = thirdColor
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:firstColor]
    
        guard let view = view as? GradientView else { return }
        
        if reverse == false {
            view.firstColor = firstColor
            view.secondColor = secondColor
            view.thirdColor = thirdColor
        } else {
            view.firstColor = thirdColor
            view.secondColor = secondColor
            view.thirdColor = firstColor
        }
        
    }
    
    func checkThemeColor(theme: String) -> (firstColor: UIColor, secondColor: UIColor, thirdColor: UIColor)? {
        let datas = Datas()
        
        switch theme {
            
            case Theme.blackAndWhite.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.blackAndWhiteFirstColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.blackAndWhiteSecondColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.blackAndWhiteThirdColor)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.classic.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstClassicColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondClassicColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdClassicColor)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.confort.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstConf)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondConf)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdConf)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.design.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstDesignColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondDesignColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdDesignColor)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.galaxy.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstGalaxyColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondGalaxyColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdGalaxyColor)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.metal.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstMetColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondMetColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdMetColor)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.natural.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.naturalFirstColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.naturalSecondColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.naturalThirdColor)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.ocean.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstOceanColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondOceanColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdOceanColor)
                return (firstColor, secondColor, thirdColor)
            
            case Theme.retro.rawValue:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstRetroColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondRetroColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdRetroColor)
                return (firstColor, secondColor, thirdColor)
            default:
            return nil
        }
    }
}


