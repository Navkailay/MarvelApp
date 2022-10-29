//
//  CollectionViewCell.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 19/10/22.
//

import Foundation
import UIKit
import UIKit

class CollectionViewCell: UICollectionViewCell, ConfigurableCell {
    var item: Any?{
        didSet {
            configure(item)
        }
    }
    
    func configure(_ item: Any?) {
         
    }
 
 //    weak var delegate: NSObjectProtocol?
 }
