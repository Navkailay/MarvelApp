//
//  SceneDelegate + Router.swift
//  ManekTechTest
//
//  Created by Navpreet Kailay on 22/09/22.
//

import Foundation
import UIKit

extension SceneDelegate {
    
    func setRootController(_ windowScene: UIWindowScene) {
        setHomeRootController(windowScene)
    }
    
    func setHomeRootController(_ windowScene: UIWindowScene){
        let window = UIWindow(windowScene: windowScene)
        let vc = HomeVC.loadFromNib()
//        let viewModel = HomeViewModel(delegate: vc)
//        viewModel.service = DefaultServiceAdapter(networkManager: NetworkManager.shared, router: Router.shared)
//        vc.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.tintColor = Colors.appGreen.color
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
}
