//
//  HomeVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit
import Combine

protocol ViewModelDelegate: AnyObject {
    func didFailed(with error: FloatError)
    func refreshUI()
    func didBeginFetching()
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    var viewModel: HomeViewModel?
    private var cancellables = Set<AnyCancellable>()
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
        fetchData(name: searchTextField.text)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    /// setups UI elements and required publishers
    func setupView() {
        searchTextField.superview?.roundedCorner(radius: 10)
        searchTextField.addDoneToKeyboard()
        searchTextField.serPlaceHolderColor(.white, text: Constants.search)
       NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: searchTextField
        )
       .compactMap({  ($0.object as? UITextField)?.text })
       .removeDuplicates()
       .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
       .sink { [unowned self] keyword in
           debugPrint("keyword: \(keyword)")
           viewModel?.fetchData(name: keyword, limit: 50, offset: 0)
        }
       .store(in: &cancellables)
           
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
    /// calls marvel api or local database to fetch data
    func fetchData(name: String?) {
        viewModel?.fetchData(name: name, limit: 20, offset: 0)
    }
    /// triggers the action called by refreshControl.
    @objc func actionRefreshControl() {
        self.fetchData(name: searchTextField.text)
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
