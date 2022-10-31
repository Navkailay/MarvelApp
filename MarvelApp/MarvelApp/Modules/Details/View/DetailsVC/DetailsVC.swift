//
//  DetailsVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit
import Combine
import Reachability

//protocol DetailsVCDelegate { }

class DetailsVC: UIViewController, ImageLoaderDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bookmarkButton: UIButton!
   
    lazy private var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        return loadingIndicator
    }()
    var viewModel: DetailsViewModel?
    var cancellable: AnyCancellable?
    var animator: UIViewPropertyAnimator?
    var reachability = try? Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        //UI
        DispatchQueue.main.async {
            self.imageView.addShadow(cornerRadius: 10)
        }
       
        self.collectionView.register(ComicCVC.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
//        self.collectionView.refreshControl = refreshControl
        // loading indicator
        loadingIndicator.center = self.collectionView.center
        self.collectionView.addSubview(loadingIndicator)
        //Datasource on UI
        titleLabel.text = viewModel?.characterViewModel?.character.title
        descriptionLabel.text = viewModel?.characterViewModel?.characterDescription
        cancellable = loadImage(for: viewModel?.characterViewModel?.largeThumbnailPath).sink { [weak self] image in
            guard let self = self else { return }
            self.showImage(image: image)
        }
//        titleLabel.superview?.setupGradient(frameBounds: self.titleLabel.superview?.bounds)
        bookmarkButton.isSelected = viewModel?.characterViewModel?.character.isBookmark ?? false
        // Fetch Data
        fetchComics()
    }
    
    func fetchComics() {
        if let id = viewModel?.characterViewModel?.character.id {
            viewModel?.fetchComics(characterId: Int(id), limit: 5)
        }
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func bookmarkAction(_ sender: Any) {
        guard let character = viewModel?.characterViewModel?.character else { return }
        viewModel?.service?.database.updateBookmark(with: Int(character.id))
        bookmarkButton.isSelected = !bookmarkButton.isSelected
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
        guard let imagePath = imagePath,
              let imageService = viewModel?.service?.imageService else { return Just(nil).eraseToAnyPublisher() }
        return Just(imagePath)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                return imageService.loadImage(from: imagePath)
            })
            .eraseToAnyPublisher()
    }
}

extension DetailsVC: ViewModelDelegate {
    func didBeginFetching() {
        
    }
    
    func didFailed(with error: FloatError) {
        self.presentFloatingAlert(with: error)

    }
    
    func refreshUI() {
        collectionView.reloadData()
    }
}
