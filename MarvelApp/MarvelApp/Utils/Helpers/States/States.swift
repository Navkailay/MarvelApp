//
//  States.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import UIKit

enum BookmarkImage: String {
    case bookmarked = "bookmarked"
    case unbookmarked = "unbookmarked"
    
    var image : UIImage? {
        return UIImage(named: self.rawValue)
    }
}
