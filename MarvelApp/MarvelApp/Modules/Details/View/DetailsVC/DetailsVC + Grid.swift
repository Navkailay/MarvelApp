//
//  DetailsVC + Grid.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 31/10/22.
//

import Foundation
import UIKit

extension DetailsVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.sectionCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = viewModel?.itemCount(section: section) ?? 0
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReusableIdentifier(indexPath: indexPath), for: indexPath) as! CollectionViewCell
        cell.item = self.viewModel?.item(section: indexPath.section,
                                         index: indexPath.item)
        return cell
    }
    
    func getReusableIdentifier(indexPath: IndexPath) -> String {
        let model = self.viewModel?.item(
            section: indexPath.section,
            index: indexPath.row
        )
        switch model {
        case _ as ComicViewModel:
            return ComicCVC.defaultResuableIdentifier
        default:
            fatalError("please configure the remaining cells or ReusableIdentifiers")
        }
    }
}

extension DetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewModel?.section(at: indexPath.section)
        let size = CGSize(width: item?.itemSize?.width ?? 0, height: collectionView.frame.size.height)
        return size
    }
}
