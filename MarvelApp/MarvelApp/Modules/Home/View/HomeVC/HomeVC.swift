//
//  HomeVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit

protocol ViewModelDelegate: AnyObject {
    func didFailed(with error: FloatError)
    func refreshUI()
    func didBeginFetching()
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    var viewModel: HomeViewModel?
    
    lazy private var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        return loadingIndicator
    }()
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupView() {
        searchTextField.superview?.roundedCorner(radius: 10)
        searchTextField.addDoneToKeyboard()
        searchTextField.serPlaceHolderColor(.white, text: Constants.search)
        self.collectionView.register(CharacterCVC.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(actionRefreshControl),
                                 for: .valueChanged)
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
    }
    
    func fetchData() {
        viewModel?.fetchData(name: nil, limit: 20, offset: 80)
    }
    /// triggers the action called by refreshControl.
    @objc func actionRefreshControl() {
        self.fetchData()
    }
}

extension HomeVC: ViewModelDelegate {
    func didBeginFetching() {
        self.loadingIndicator.startAnimating()
    }
    
    
    func didFailed(with error: FloatError) {
        DispatchQueue.main.async {
            self.presentFloatingAlert(with: error)
        }
    }
    
    func refreshUI() {
        refreshControl.endRefreshing()
        loadingIndicator.stopAnimating()
        collectionView.reloadData()
    }
    
}
