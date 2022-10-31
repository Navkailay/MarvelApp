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
 
    func setupGradient(frameBounds: CGRect?){
        guard let frameBounds = frameBounds else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frameBounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: UIImageView

extension UIImageView {
    func addShadow(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true

        self.superview?.layer.cornerRadius = cornerRadius
        self.superview?.layer.masksToBounds = false

        self.superview?.layer.shadowColor = UIColor.lightGray.cgColor
        self.superview?.layer.shadowOffset = .zero //CGSize(width: 4, height: 4)
        self.superview?.layer.shadowOpacity = 0.8
        self.superview?.layer.shadowRadius = 8.0

         self.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
    }
}
