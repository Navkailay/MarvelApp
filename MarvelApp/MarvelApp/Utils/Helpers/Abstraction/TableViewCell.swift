//
//  TableView.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 19/10/22.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell, ConfigurableCell {
    var item: Any?{
        didSet {
            configure(item)
        }
    }
    func configure(_ item: Any?) { }
 //    weak var delegate: NSObjectProtocol?
}

