//
//  ReusableView.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 18/10/22.
//

import Foundation
import UIKit

protocol ReusableView : AnyObject {
     static var defaultResuableIdentifier : String { get }
}

extension ReusableView where Self : UIView {
   static var defaultResuableIdentifier : String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView { }
extension UITableViewCell: ReusableView { }
