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
