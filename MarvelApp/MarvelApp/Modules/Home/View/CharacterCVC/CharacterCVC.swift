//
//  CharacterCVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit
import Combine

class CharacterCVCViewModel {
    var character : CharacterData
    var service : ImageLoaderService?
    
    init(character: CharacterData, service: ImageLoaderService? = nil) {
        self.character = character
        self.service = service
    }
    
    var smallThumbnailPath: String {
         "\(character.thumbnail.path)/\(MarvelImageSizeConfiguration.standard_xlarge.rawValue).\(character.thumbnail.thumbnailExtension)"
    }
}


class CharacterCVC: CollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
     var service : ImageLoaderService?
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.imgView.makeCircular()
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
        guard let item = item as? CharacterCVCViewModel else { return }
        service = item.service
        titleLabel.text = item.character.name
        cancellable = loadImage(for: item.smallThumbnailPath).sink { [weak self] image in
            guard let self = self else { return }
            self.showImage(image: image)
        }
    }
    
    private func showImage(image: UIImage?) {
        imgView.alpha = 0.0
        animator?.stopAnimation(false)
        imgView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.imgView.alpha = 1.0
        })
    }
    
    private func loadImage(for imagePath: String) -> AnyPublisher<UIImage?, Never> {
        guard let service = service else { return Just(nil).eraseToAnyPublisher() }
         return Just(imagePath)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                return service.imageLoader.loadImage(from: imagePath)
            })
            .eraseToAnyPublisher()
    }
}

