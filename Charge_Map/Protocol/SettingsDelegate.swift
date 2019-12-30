//
//  SettingsDelegate.swift
//  Charge_Map
//
//  Created by Macbook pro on 27/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

enum Theme {
    
    case blackAndWhite
    case classic
    case natural
    case metal
    case design
    case ocean
    case retro
    case confort
    case galaxy
}

protocol SettingsDelegate {}

extension SettingsDelegate {
    
    func convertDatasColorToUIColor(datasColor: (red: Double, green:
        Double, blue: Double , alpha: Int)) -> UIColor {
        let color = UIColor(red: CGFloat(datasColor.red), green: CGFloat(datasColor.green), blue: CGFloat(datasColor.blue), alpha: CGFloat(datasColor.alpha))
        return color
    }
    
    func applyTheme(theme: Theme, view: GradientView, navigationBar: UINavigationBar?, reverse: Bool) {
        Datas.choosenTheme = theme
        let themeColors = checkThemeColor(theme: theme)
        navigationBar?.barTintColor = themeColors.secondColor
        navigationBar?.tintColor = themeColors.thirdColor
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor:themeColors.firstColor]
        if reverse == false {
            view.firstColor = themeColors.firstColor
            view.secondColor = themeColors.secondColor
            view.thirdColor = themeColors.thirdColor
        } else {
            view.firstColor = themeColors.thirdColor
            view.secondColor = themeColors.secondColor
            view.thirdColor = themeColors.firstColor
        }
        
    }
    
    func checkThemeColor(theme: Theme) -> (firstColor: UIColor, secondColor: UIColor, thirdColor: UIColor) {
        let datas = Datas()
        
        switch theme {
            
            case .blackAndWhite:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.blackAndWhiteFirstColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.blackAndWhiteSecondColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.blackAndWhiteThirdColor)
                return (firstColor, secondColor, thirdColor)
            
            case .classic:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstClassicColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondClassicColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdClassicColor)
                return (firstColor, secondColor, thirdColor)
            
            case .confort:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstConf)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondConf)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdConf)
                return (firstColor, secondColor, thirdColor)
            
            case .design:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstDesignColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondDesignColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdDesignColor)
                return (firstColor, secondColor, thirdColor)
            
            case .galaxy:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstGalaxyColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondGalaxyColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdGalaxyColor)
                return (firstColor, secondColor, thirdColor)
            
            case .metal:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstMetColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondMetColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdMetColor)
                return (firstColor, secondColor, thirdColor)
            
            case .natural:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.naturalFirstColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.naturalSecondColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.naturalThirdColor)
                return (firstColor, secondColor, thirdColor)
            
            case .ocean:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstOceanColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondOceanColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdOceanColor)
                return (firstColor, secondColor, thirdColor)
            
            case .retro:
                let firstColor = convertDatasColorToUIColor(datasColor: datas.firstRetroColor)
                let secondColor = convertDatasColorToUIColor(datasColor: datas.secondRetroColor)
                let thirdColor = convertDatasColorToUIColor(datasColor: datas.thirdRetroColor)
                return (firstColor, secondColor, thirdColor)
        }
    }
}


