//
//  UIView+Extension.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import Foundation
import UIKit

extension UIView {
    func rotate(angle: CGFloat, transform: CGAffineTransform) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = transform.rotated(by: radians)
        self.transform = rotation
    }
}
extension UIView {
    
    @IBInspectable var cornerRadius : CGFloat {
        
        get {cornerRadius}
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
