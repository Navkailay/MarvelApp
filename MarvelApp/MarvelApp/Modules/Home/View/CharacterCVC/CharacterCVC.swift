//
//  CharacterCVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit
import Combine

class CharacterCVC: CollectionViewCell, ImageLoaderDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    var cancellable: AnyCancellable?
    var animator: UIViewPropertyAnimator?
    var service : ImageLoaderService?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.imgView.roundedCorner(radius: 8)
            self.setupLongPressGesture()
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        imgView.alpha = 0.0
        bookmarkImage.isHidden = true
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
    
    override func configure(_ item: Any?) {
        guard let item = item as? CharacterViewModel else { return }
        service = item.service
        titleLabel.text = item.character.title
        bookmarkImage.isHidden = item.character.isBookmark == false
        if item.character.isBookmark {
            bookmarkImage.image = UIImage(systemName: "star.fill")
        }
        cancellable = loadImage(for: item.smallThumbnailPath)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.showImage(image: image)
            }
    }
    
    func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(toggleBookmark))
        longPressGesture.minimumPressDuration = 1
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func toggleBookmark( _ sender: Any) {
        guard let item = item as? CharacterViewModel, let sender = sender as? UILongPressGestureRecognizer else { return }
        if sender.state != .recognized {
            item.databaseService?.updateBookmark(with: Int(item.character.id))
            item.bookmarkToggled?(item.character)
            delegate?.didtoggleBookmark(at: indexPath)
        }
    }
    
    internal func showImage(image: UIImage?) {
        imgView.alpha = 0.0
        animator?.stopAnimation(false)
        imgView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let self else { return }
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

