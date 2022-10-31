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
    case failureRed
    case marvelRed
    
    var color: UIColor {
        switch self {
        case .marvelRed: return UIColor(named: "marvelRed") ?? .red
        case .appGreen: return UIColor(named: "appGreen") ?? .systemGreen
        case .failureRed:  return .red
        }
    }
    
}
