//
//  MapscreenViewContoller+CollectionView.swift
//  CheapEats
//
//  Created by Emre on 5.03.2025.
//
import UIKit
import MapKit

extension MapScreenViewController:  UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = mapScreenViewModel.productDetail.count
        return count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MapCollectionViewCell
        let product = mapScreenViewModel.productDetail[indexPath.row]
        cell.configure(productDetail: product, distance: mapScreenViewModel.getFormattedDistance(for: product.restaurant.restaurantId))
        let isSelected = mapScreenViewModel.isRestaurantSelected(product.restaurant.restaurantId)
        cell.setHighlighted(isSelected)
        cell.detailButtonTapped = { [weak self] in
            guard let self = self else { return }
            clickDetailButton(with: mapScreenViewModel.productDetail[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 0.7
        let height = collectionView.frame.size.height * 0.9
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetail = mapScreenViewModel.productDetail[indexPath.row]
        mapScreenViewModel.selectRestaurant(withId: productDetail.restaurant.restaurantId)
        centerMapOnProductLocation(productDetail: productDetail)
    }

    private func centerMapOnProductLocation(productDetail: ProductDetails) {
        mapScreenViewModel.selectRestaurant(withId: productDetail.restaurant.restaurantId)
        let coordinate = CLLocationCoordinate2D(latitude: productDetail.restaurant.location.latitude, longitude: productDetail.restaurant.location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut], animations: {
            self.mapView.setRegion(region, animated: true)
        }, completion: { _ in
            if let annotation = self.mapView.annotations.first(where: { $0.coordinate.latitude == coordinate.latitude && $0.coordinate.longitude == coordinate.longitude }) {
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        })
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionViewSettings(with collectionView: UICollectionView) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
    }
    
    func clickDetailButton(with productDetail: ProductDetails) {
        let detailVC = SB.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.detailViewModel.productDetail = productDetail
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
