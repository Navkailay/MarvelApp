//
//  UICollectionView.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 18/10/22.
//

import Foundation
import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_ : T.Type) {
         self.register(UINib(nibName: T.nibName, bundle: nil), forCellWithReuseIdentifier: T.defaultResuableIdentifier)
    }
    
     func dequeueReusable<T: UICollectionViewCell>(_ T: T.Type, indexPath: IndexPath)  -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultResuableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultResuableIdentifier)")
        }
        return cell
    }
    
    
}
