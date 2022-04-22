//
//  CollectionTopRank.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 2/4/2565 BE.
//

import UIKit
import RxCocoa
import RxSwift

class CollectionCoinTopRank: UITableViewCell {
    static let reuseId = "CollectionCoinTopRank"
    var viewModel: MainInterface!
    let disposeBag = DisposeBag()
    
    var topRankCoin: [CoinDisplayViewModel]! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!  {
        didSet {
            collectionView.bounces = false
            collectionView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet{
            collectionViewFlowLayout.minimumInteritemSpacing = 0
            collectionViewFlowLayout.minimumLineSpacing = 0
        }
    }
    
    override func awakeFromNib() {
        setupOrientationChangedEvt()
        setupCollectionView()
    }
    
    func setupOrientationChangedEvt() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
        
        //        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { data in
        //                print("data \(data)")
        //                self.collectionView.reloadData()
        //
        //            })
        //            .disposed(by: disposeBag)
    }
    @objc func orientationChanged(notification : NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.collectionView.reloadData()
        }
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            UINib(nibName: CollectionCoinTopRankCell.reuseId,bundle: nil),
            forCellWithReuseIdentifier: CollectionCoinTopRankCell.reuseId
        )
    }
}

extension CollectionCoinTopRank: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let topRankCoin = topRankCoin else { return 0 }
        return topRankCoin.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCoinTopRankCell.reuseId, for: indexPath) as! CollectionCoinTopRankCell
        let coinViewModel = topRankCoin![indexPath.row]
        cell.coinViewModel = coinViewModel
        return cell
    }
    
    
}

extension CollectionCoinTopRank: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: collectionView.frame.width / 3,
            height:  collectionView.frame.height
        )
    }
}

extension CollectionCoinTopRank: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let uuid = topRankCoin[indexPath.row].uuid
        else { return }
        
        viewModel.input.viewCoinDetail(uuid: uuid)
    }
}


