//
//  SettingViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 26/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, SettingsDelegate {

    @IBOutlet var gradientView: GradientView!
    @IBOutlet weak var freeAnnotationsSwitch: UISwitch!
    
    var annotationManager: AnnotationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        freeAnnotationsSwitch.isOn = annotationManager.filterIsOn
        navigationController?.navigationBar.isHidden = false
        guard let view = view as? GradientView else { return }
        applyTheme(theme: Datas.choosenTheme, view: view, navigationBar: navigationController?.navigationBar, reverse: false)
    }
    
    @IBAction func ChangeInterfaceColor(_ sender: UIButton) {
        let navigationBar = navigationController?.navigationBar
        guard let gradientView = view as? GradientView else { return }
        switch sender.tag {
            case 1:
                applyTheme(theme: .blackAndWhite, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 2:
                applyTheme(theme: .classic, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 3:
                applyTheme(theme: .ocean, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 4:
                applyTheme(theme: .natural, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 5:
                applyTheme(theme: .metal, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 6:
                applyTheme(theme: .design, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 7:
                applyTheme(theme: .retro, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 8:
                applyTheme(theme: .confort, view: gradientView, navigationBar: navigationBar, reverse: false)
            case 9:
                applyTheme(theme: .galaxy, view: gradientView, navigationBar: navigationBar, reverse: false)
            default:
            break
        }
    }
    
    @IBAction func filterFreeAnnotationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            annotationManager.filterIsOn = true
        } else {
            annotationManager.filterIsOn = false
        }
    }
    
}
