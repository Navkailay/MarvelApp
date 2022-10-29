//
//  HomeVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
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
        self.collectionView.register(CharacterCVC.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    func setupViewModel() {
//        self.viewModel = HomeViewModel(delegate: self)
        viewModel?.fetchData(name: nil, limit: 10, offset: 50)
    }
}

extension HomeVC: HomeViewModelDelegate {
    func didFailed(with error: FloatError) {
        self.presentFloatingAlert(with: error)

    }
    
    func refreshData() {
        collectionView.reloadData()
    }
    
    
}
