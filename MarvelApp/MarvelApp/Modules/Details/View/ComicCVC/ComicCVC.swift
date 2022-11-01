//
//  ComicCVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 31/10/22.
//

import UIKit
import Combine

class ComicCVC: CollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var cancellable: AnyCancellable?
    var animator: UIViewPropertyAnimator?
    var service : ImageLoaderService?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
             self.imgView.addShadow(cornerRadius: 4, shadowRadius: 4)
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        imgView.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
    
    override func configure(_ item: Any?) {
        guard let item = item as? ComicViewModel else { return }
        service = item.service
        titleLabel.text = item.comic?.title
        cancellable = loadImage(for: item.largeThumbnailPath).sink { [weak self] image in
            guard let self = self else { return }
            self.showImage(image: image)
        }
    }
    
    internal func showImage(image: UIImage?) {
        imgView.alpha = 0.0
        animator?.stopAnimation(false)
        imgView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.imgView.alpha = 1.0
        })
    }
    
    internal func loadImage(for imagePath: String?) -> AnyPublisher<UIImage?, Never> {
        guard let imagePath = imagePath, let service = service else { return Just(nil).eraseToAnyPublisher() }
        return Just(imagePath)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                return service.imageLoader.loadImage(from: imagePath)
            })
            .eraseToAnyPublisher()
    }
}

