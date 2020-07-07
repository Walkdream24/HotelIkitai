//
//  HotelListViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/01.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreLocation
import NVActivityIndicatorView

protocol HotelListView: class {
    func presentActivityIndicator(message: String)
    func dismissActivityIndicator()
    func toDetail()
    func reLoad()
}
class HotelListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: HotelListPresenter!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var nowLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:self.view.frame.width - 40, height:(self.view.frame.width - 40) * 0.95)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.hotelListCollectionViewCell)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    static func instantiate(forType type: Category) -> HotelListViewController {
        let vc = R.storyboard.hotelList.hotelList()!
        vc.presenter = HotelListPresenter(view: vc, type: type)
        return vc
    }

}

extension HotelListViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: presenter?.categoryType.displayName)
    }
    
}

extension HotelListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.hotelItem.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.hotelListCollectionViewCell, for: indexPath)!
        cell.configure(with: presenter.hotelItem[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.toDetail()
    }

}

extension HotelListViewController: HotelListView, NVActivityIndicatorViewable {
    func reLoad() {
        collectionView.reloadData()
    }
    
    func presentActivityIndicator(message: String) {
        startAnimating(message: message)
    }
    
    func dismissActivityIndicator() {
        stopAnimating()
    }
    
    func toDetail() {
        let vc = R.storyboard.hotelDetail.hotelDetail()!
         navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
