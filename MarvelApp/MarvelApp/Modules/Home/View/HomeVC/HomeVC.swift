//
//  HomeVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit

protocol ViewModelDelegate: AnyObject {
    func didFailed(with error: FloatError)
    func refreshData()
 }

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupView(){
        searchTextField.superview?.roundedCorner(radius: 10)
        searchTextField.addDoneToKeyboard()
        searchTextField.serPlaceHolderColor(.white, text: Constants.search)
        self.collectionView.register(CharacterCVC.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    func setupViewModel() {
//        self.viewModel = HomeViewModel(delegate: self)
        viewModel?.fetchData(name: nil, limit: 20, offset: 80)
    }
}

extension HomeVC: ViewModelDelegate {
    func didFailed(with error: FloatError) {
        self.presentFloatingAlert(with: error)

    }
    
    func refreshData() {
        collectionView.reloadData()
    }
    
    
}
