//
//  Datas.swift
//  Charge_Map
//
//  Created by Macbook pro on 10/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import Foundation
import MapKit

class Datas {
    
    static var startPointGradient = CGPoint(x: 0.0, y: 0.4)
    static var endPointGradient = CGPoint(x: 0.4, y: 1.0)
    static var choosenTheme: Theme = .classic
    
    
    // CLLocationCoordinate2D(latitude: 48.0909, longitude: 2.0302)
    static var coordinateUser =  CLLocationCoordinate2D()
    var setRegionMeters = (latitude: CLLocationDistance(90000), longitude: CLLocationDistance(90000))
    let alpha: CGFloat = 1.0
    var cornerRadius: CGFloat = 0
    
    // MARK: - Colors
    let blackAndWhiteFirstColor = (red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
    let blackAndWhiteSecondColor = (red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
    let blackAndWhiteThirdColor = (red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    
    
    let firstClassicColor = (red: 0.5, green: 0.1198409358, blue: 0.08705774756, alpha: 1)
    let secondClassicColor = (red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
    let thirdClassicColor = (red: 0.8122976036, green: 0.1359092446, blue: 0.1255913831, alpha: 1)
    
    let naturalFirstColor = (red: 0.0, green: 0.4040677374, blue: 0.06285081267, alpha: 1)
    let naturalSecondColor = (red: 0.1424810396, green: 0.1653500349, blue: 0.08682758909, alpha: 1)
    let naturalThirdColor = (red: 0.0, green: 0.4993889665, blue: 0.07767757599, alpha: 1)
    
    let firstMetColor = (red: 0.171343782, green: 0.173040255, blue: 0.173040255, alpha: 1)
    let secondMetColor = (red: 0.2561550964, green: 0.2586912855, blue: 0.2586912855, alpha: 1)
    let thirdMetColor = (red: 0.418663, green: 0.4228081782, blue: 0.4228081782, alpha: 1)
    
    let firstConf = (red: 0.543404981, green: 0.3154038713, blue: 0.2222459068, alpha: 1)
    let secondConf = (red: 0.7154782678, green: 0.7054466575, blue: 0.4345897804, alpha: 1)
    let thirdConf = (red: 0.7855329949, green: 0.3669982301, blue: 0.3327769533, alpha: 1)
    
    let firstDesignColor = (red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)
    let secondDesignColor = (red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
    let thirdDesignColor = (red: 0.7510323212, green: 0.7843137255, blue: 0.7577497322, alpha: 1)
    
    let firstOceanColor = (red: 0.05612730505, green: 0.04509177891, blue: 0.2566227792, alpha: 1)
    let secondOceanColor = (red: 0.007930106001, green: 0.203559394, blue: 0.5461215102, alpha: 1)
    let thirdOceanColor = (red: 0.149047988, green: 0.4681743273, blue: 0.5597239848, alpha: 1)
    
    let firstGalaxyColor = (red: 0.05612730505, green: 0.04509177891, blue: 0.2566227792, alpha: 1)
    let secondGalaxyColor = (red: 0.007930106001, green: 0.203559394, blue: 0.5461215102, alpha: 1)
    let thirdGalaxyColor = (red: 0.05612730505, green: 0.04509177891, blue: 0.2566227792, alpha: 1)
    
    let firstRetroColor = (red: 0.3781329315, green: 0.2107013669, blue: 0.0007822256497, alpha: 1)
    let secondRetroColor = (red: 0.2115521891, green: 0.1698993293, blue: 0.0920054186, alpha: 1)
    let thirdRetroColor = (red: 0.1999920685, green: 0.1205488933, blue: 0.05442363618, alpha: 1)
}
