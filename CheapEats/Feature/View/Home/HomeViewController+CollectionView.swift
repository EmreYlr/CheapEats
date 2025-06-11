//
//  EndlingCollectionView+HomeViewController.swift
//  CheapEats
//
//  Created by Emre on 27.11.2024.
//

import Foundation
import UIKit

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = homeViewModel.productDetailsList.count
        return count >= 4 ? 4 : count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OrderCollectionViewCell
        if collectionView == endlingCollectionView {
            let product = homeViewModel.endlingProduct[indexPath.row]
            cell.configureCell(productDetail: product)
            
        } else if collectionView == recommendedCollectionView {
            let product = homeViewModel.recommendedProduct[indexPath.row]
            cell.configureCell(productDetail: product)
            
        } else if collectionView == closeCollectionView {
            if indexPath.row >= homeViewModel.closeProduct.count {
                return UICollectionViewCell()
            }
            let product = homeViewModel.closeProduct[indexPath.row]
                cell.configureCell(productDetail: product)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 0.7
        let height = collectionView.frame.size.height * 0.9
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = SB.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if collectionView == endlingCollectionView {
            let product = homeViewModel.endlingProduct[indexPath.row]
                detailVC.detailViewModel.productDetail = product
        } else if collectionView == recommendedCollectionView {
            let product = homeViewModel.recommendedProduct[indexPath.row]
                detailVC.detailViewModel.productDetail = product
            
        } else if collectionView == closeCollectionView {
            let product = homeViewModel.closeProduct[indexPath.row]
                detailVC.detailViewModel.productDetail = product
            
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionViewSettings(with collectionView: UICollectionView) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .BG
        collectionView.layer.cornerRadius = 10
    }
}
