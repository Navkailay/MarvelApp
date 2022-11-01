//
//  NibLoadableView.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 18/10/22.
//

import Foundation
import UIKit
/// default implementation using protocol extensions.
protocol NibLoadableView: AnyObject {
     static var nibName: String { get }
 }

extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell : NibLoadableView { }
extension UICollectionViewCell : NibLoadableView { }
