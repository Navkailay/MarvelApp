//
//  HomeVC + Grid.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import Foundation
import UIKit

extension HomeVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.sectionCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.itemCount(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReusableIdentifier(indexPath: indexPath), for: indexPath) as! CollectionViewCell
        cell.item = self.viewModel?.item(section: indexPath.section,
                                          index: indexPath.row)
        
        return cell
    }
    
    func getReusableIdentifier(indexPath: IndexPath) -> String {
        let model = self.viewModel?.item(
            section: indexPath.section,
            index: indexPath.row
        )
        switch model {
        case _ as CharacterCVCViewModel:
            return CharacterCVC.defaultResuableIdentifier
          default:
            fatalError("please configure the remaining cells or ReusableIdentifiers")
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSide = collectionView.bounds.width/3 - 10
        let size = CGSize(width: cellSide, height: cellSide)
        return size
    }
}
