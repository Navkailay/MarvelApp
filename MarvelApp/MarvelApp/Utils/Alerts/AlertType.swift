//
//  AlertType.swift
//  ManekTechTest
//
//  Created by Navpreet Kailay on 22/09/22.
//

import Foundation
import UIKit.UIColor

public enum AlertType{
    case failure
    case success
    case loading
   
    var backgroundColor: UIColor{
        switch self {
        case .failure:
            return Colors.failureRed.color
        case .success:
            return Colors.appGreen.color
        case .loading:
            return UIColor.orange //Colors.appGreen.color
        }
    }
}
