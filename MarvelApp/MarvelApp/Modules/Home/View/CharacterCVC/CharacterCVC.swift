//
//  CharacterCVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit
import Combine

class CharacterViewModel {
    var character : MCCharacter
    var service : ImageLoaderService?
    
    init(character: MCCharacter, service: ImageLoaderService? = nil) {
        self.character = character
        self.service = service
    }
    
    var smallThumbnailPath: String {
        guard let thumbnail = character.thumbnail else { return ""  }
        return  "\(thumbnail.path)/\(MarvelImageSizeConfiguration.standard_xlarge.rawValue).\(thumbnail.thumbnailExtension)"
        
     }
    
    var largeThumbnailPath: String {
        guard let thumbnail = character.thumbnail else { return ""  }

       return  "\(thumbnail.path)/\(MarvelImageSizeConfiguration.portrait_incredible.rawValue).\(thumbnail.thumbnailExtension)"
    }
    
    var characterDescription: String {
        guard let characterDescription = character.characterDescription else { return Constants.Message.noDescription }
        let desc = characterDescription.isEmpty ? Constants.Message.noDescription : characterDescription
        return desc
    }
}


class CharacterCVC: CollectionViewCell, ImageLoaderDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var cancellable: AnyCancellable?
    var animator: UIViewPropertyAnimator?
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
        guard let item = item as? CharacterViewModel else { return }
        service = item.service
        titleLabel.text = item.character.title
        cancellable = loadImage(for: item.smallThumbnailPath).sink { [weak self] image in
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

