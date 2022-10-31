//
//  ConfigurableCell.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 19/10/22.
//

import Foundation
import UIKit

protocol ConfigurableCell: AnyObject{
    var item: Any? { get }
    func configure(_ item: Any?) 

}

 
