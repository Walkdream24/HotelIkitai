//
//  SearchListViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/17.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView
import CoreLocation
import SPAlert

protocol SearchListView: class {
    func presentActivityIndicator(message: String)
    func dismissActivityIndicator()
    func reLoad()
    func toDetail(hotel: HotelItem, restMin: Int, stayMin: Int, latitude: Double, longitude: Double, distance: Double)
    func showCompleteMessage()
    func resultNothing()
}

protocol SearchListInterface: class {
    func searchStart(searchWord: String, nowLocation:CLLocation)
}

class SearchListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: SearchListPresenter!
    var emptyView: EmptyView!
    var nothingView: NothingResultsView!
    var searchWord = ""
//    var latitude: CLLocationDegrees?
//    var longitude: CLLocationDegrees?
    var nowLocation: CLLocation?
    var hotelImageUrl: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView = EmptyView.instantiate()
        collectionView.backgroundView = emptyView
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
        super.viewWillAppear(true)
        print("eeeeeeee\(presenter.categoryType)")
    }
    
    static func instantiate(forType type: Category) -> SearchListViewController {
        let vc = R.storyboard.searchList.searchList()!
        vc.presenter = SearchListPresenter(view: vc, type: type)
        vc.nothingView = NothingResultsView.instantiate(presenter: vc.presenter)
        return vc
    }

}
extension SearchListViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: presenter?.categoryType.displayName)
    }
}
extension SearchListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.hotelItem.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.hotelListCollectionViewCell, for: indexPath)!
        cell.configure(with: presenter.hotelItem[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hotelImageUrl = presenter.hotelItem[indexPath.item].imageUrl
        presenter.toDetail(hotel: presenter.hotelItem[indexPath.row], restMin: presenter.hotelItem[indexPath.row].restMin, stayMin: presenter.hotelItem[indexPath.row].stayMin, latitude: presenter.hotelItem[indexPath.row].latitude, longitude: presenter.hotelItem[indexPath.row].longitude, distance: presenter.hotelItem[indexPath.row].distance)
    }
}
    
extension SearchListViewController: SearchListView, NVActivityIndicatorViewable {
    
    func resultNothing() {
        if collectionView != nil {
            nothingView.searchText = searchWord
            nothingView.setSearchText()
            self.collectionView.backgroundView = nothingView
        } else {
            print("nilです")
        }
    }
    
    func showCompleteMessage() {
        SPAlert.present(title: "送信しました", preset: .done)
        collectionView.backgroundView = nil
    }
    
    func toDetail(hotel: HotelItem, restMin: Int, stayMin: Int, latitude: Double, longitude: Double, distance: Double) {
        let vc = HotelDetailViewController.instantiate(for: hotel)
        vc.hotelImageUrl = hotelImageUrl
        vc.restMin = restMin
        vc.stayMin = stayMin
        vc.latitude = latitude
        vc.longitude = longitude
        vc.distance = distance
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reLoad() {
        if collectionView != nil {
            collectionView.backgroundView = nil
            self.collectionView.reloadData()
        } else {
            print("nilです")
        }
    }
    
    func presentActivityIndicator(message: String) {
        startAnimating(message: message)
    }
    
    func dismissActivityIndicator() {
        stopAnimating()
    }
    
}
extension SearchListViewController: SearchViewInterface {
    func searchStart(searchWord: String, nowLocation: CLLocation) {
        presenter.searchStart(searchWord: searchWord, nowLocation: nowLocation)
        self.searchWord = searchWord
    }
    
}


