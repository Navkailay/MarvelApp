//
//  UITextField.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 29/09/22.
//

import Foundation
import UIKit.UITextField
import Combine

extension UITextField {
    func addDoneToKeyboard() {
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Done",
                                    style: .plain,
                                    target: self,
                                    action: #selector(dismissKeyboard))
        reset.tintColor = .black
        bar.items = [UIBarButtonItem.flexibleSpace(), reset]
        bar.sizeToFit()
        self.inputAccessoryView = bar
    }
    
    @objc func dismissKeyboard(){
        self.endEditing(true)
    }
    
    // Combine
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .map { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
    
    func serPlaceHolderColor(_ color: UIColor, text: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
}
