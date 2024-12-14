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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OrderCollectionViewCell
        if collectionView == endlingCollectionView {
            if let product = homeViewModel.endlingProduct?[indexPath.row] {
                cell.configureCell(product: product)
            }
        } else if collectionView == recommendedCollectionView {
            if let product = homeViewModel.recommendedProduct?[indexPath.row] {
                cell.configureCell(product: product)
            }
        } else if collectionView == closeCollectionView {
            if let product = homeViewModel.closeProduct?[indexPath.row] {
                cell.configureCell(product: product)
            }
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
            if let product = homeViewModel.endlingProduct?[indexPath.row] {
                detailVC.detailViewModel.product = product
            }
        } else if collectionView == recommendedCollectionView {
            if let product = homeViewModel.recommendedProduct?[indexPath.row] {
                detailVC.detailViewModel.product = product
            }
        } else if collectionView == closeCollectionView {
            if let product = homeViewModel.closeProduct?[indexPath.row] {
                detailVC.detailViewModel.product = product
            }
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionViewLayoutSettings() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        endlingCollectionView.collectionViewLayout = layout
        endlingCollectionView.isPagingEnabled = false
        endlingCollectionView.showsHorizontalScrollIndicator = false
        endlingCollectionView.backgroundColor = .BG
        endlingCollectionView.layer.cornerRadius = 10
    }
    
    func endlingViewLayoutSettings() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        recommendedCollectionView.collectionViewLayout = layout
        recommendedCollectionView.isPagingEnabled = false
        recommendedCollectionView.showsHorizontalScrollIndicator = false
        recommendedCollectionView.backgroundColor = .BG
        recommendedCollectionView.layer.cornerRadius = 10
    }
    func closeViewLayoutSettings() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        closeCollectionView.collectionViewLayout = layout
        closeCollectionView.isPagingEnabled = false
        closeCollectionView.showsHorizontalScrollIndicator = false
        closeCollectionView.backgroundColor = .BG
        closeCollectionView.layer.cornerRadius = 10
    }
}
