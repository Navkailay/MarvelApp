//
//  DetailsVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit
import Combine

protocol DetailsVCDelegate { }

class DetailsVC: UIViewController, ImageLoaderDelegate {
    
    var cancellable: AnyCancellable?
    var animator: UIViewPropertyAnimator?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: DetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        titleLabel.text = viewModel?.characterViewModel?.character.name
        descriptionLabel.text = viewModel?.characterViewModel?.characterDescription
        cancellable = loadImage(for: viewModel?.characterViewModel?.largeThumbnailPath).sink { [weak self] image in
            guard let self = self else { return }
            self.showImage(image: image)
        }
        titleLabel.superview?.setupGradient(frameBounds: self.titleLabel.superview?.bounds)
    }
    
     
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension DetailsVC {
    func showImage(image: UIImage?) {
        imageView.alpha = 0.0
        animator?.stopAnimation(false)
        imageView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.imageView.alpha = 1.0
        })
    }
    
    func loadImage(for imagePath: String?) -> AnyPublisher<UIImage?, Never> {
        guard let imagePath = imagePath, let service = viewModel?.service else { return Just(nil).eraseToAnyPublisher() }
        return Just(imagePath)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                return service.loadImage(from: imagePath)
            })
            .eraseToAnyPublisher()
    }
}

extension DetailsVC: DetailsVCDelegate { }

extension UIView {
    func setupGradient(frameBounds: CGRect?){
        guard let frameBounds = frameBounds else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frameBounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
