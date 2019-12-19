//
//  CustomGradientView.swift
//  Charge_Map
//
//  Created by Macbook pro on 04/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    // MARK: - Properties
    var gradientLayer: CAGradientLayer?

    @IBInspectable var firstColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var secondColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var thirdColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    var endPointX: CGFloat = 0.4 {
        didSet {
            setNeedsLayout()
        }
    }

    var startPointY: CGFloat = 0.4 {
        didSet {
            setNeedsLayout()
        }
    }

    var endPointY: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        gradientLayer?.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer?.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientLayer?.cornerRadius = cornerRadius
    }
}
