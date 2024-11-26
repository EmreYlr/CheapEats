//
//  ViewController.swift
//  CheapEats
//
//  Created by Emre on 24.11.2024.
//

import UIKit

final class HomeViewController: UIViewController{
    //MARK: -Variables
    @IBOutlet weak var collectionView: UICollectionView!
    private var homeViewModel : HomeViewModelProtocol = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello World")
        homeViewModel.delegate = self
        initLoad()
        collectionViewLayoutSettings()
        
    }
    private func initLoad(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: "OrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    private func collectionViewLayoutSettings() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) // Kenar boşlukları
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = true
        //collectionView.backgroundColor = .red
    }
}

extension HomeViewController : HomeViewModelOutputProtocol {
    func update() {
        print("Update")
    }
    
    func error() {
        print("Error")
    }
}
//MARK: -CollectionView
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OrderCollectionViewCell
        cell.imageView.image = UIImage(named: "Logo")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.size.width * 0.5
        let height = collectionView.frame.size.height * 0.9 // Hücre yüksekliği
            return CGSize(width: width, height: height)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5 // Hücreler arasındaki boşluk
    }
    
}
