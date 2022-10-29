//
//  ImageLoader.swift
//  ManekTechTest
//
//  Created by Navpreet Kailay on 22/09/22.
//

import Foundation
import UIKit.UIImage
import Combine

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }

    public func loadImage(from imagePath: String) -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: imagePath) else {
            return Just(nil).eraseToAnyPublisher()
        }
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .print("Image loading \(url):")
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
