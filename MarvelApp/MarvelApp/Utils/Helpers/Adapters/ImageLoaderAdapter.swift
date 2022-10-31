//
//  ImageLoaderAdapter.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import Combine
import UIKit
struct ImageLoaderService {
    let imageLoader: ImageLoader
}


protocol ImageLoaderDelegate {
    var cancellable: AnyCancellable? { get }
    var animator: UIViewPropertyAnimator? { get }
    
    
    func showImage(image: UIImage?)
    func loadImage(for imagePath: String?) -> AnyPublisher<UIImage?, Never>
}
