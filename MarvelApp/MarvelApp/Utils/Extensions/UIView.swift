//
//  UIView.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import UIKit

public extension UIView {
    func roundedCorner(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func makeCircular() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
}
