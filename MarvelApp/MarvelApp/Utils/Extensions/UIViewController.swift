//
//  Extensions.swift
//  GCalendar
//
//  Created by Navpreet Kailay on 17/09/22.
//

import Foundation
import UIKit

//enum Storyboard: String {
//    
//    case main = "Main"
//    
//    var storyboard : UIStoryboard {
//        let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
//        return storyboard
//    }
//}

extension UIViewController {
    
    static func loadFromNib() -> Self {
       func instantiateFromNib<T: UIViewController>() -> T {
           return T.init(nibName: String(describing: T.self), bundle: nil)
       }
       return instantiateFromNib()
   }
    
    func presentFloatingAlert(with floatError: FloatError){
        DispatchQueue.main
            .async {
                debugPrint("alert with message: \(floatError.message)")
                let alertHeight: CGFloat = 80
                let alert = FloatAlertView(frame: CGRect(x: 0, y: -alertHeight, width: self.view.bounds.width, height: alertHeight))
                alert.messageLabel.text = floatError.message.capitalized
                alert.messageLabel.textColor = floatError.type == .failure ? .white : .black
                alert.messageLabel.superview?.backgroundColor = floatError.type.backgroundColor
                self.view.addSubview(alert)

                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                    alert.frame.origin.y = 0
                } completion: { completed in
                    alert.removeAlert()
                }
            }
    }
    
    
    func alert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
