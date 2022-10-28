//
//  Colors.swift
//  ManekTechTest
//
//  Created by Navpreet Kailay on 22/09/22.
//

import Foundation
import UIKit.UIColor

public enum Colors {
      case appGreen
 
    var color: UIColor {
        switch self {
          case .appGreen:
            return UIColor(named: "appGreen") ?? .green
         }
    }
    
}
