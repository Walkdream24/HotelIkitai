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
    func toDetail(hotel: HotelItem, restMin: Int, stayMin: Int)
    func reLoad()
//    func location() -> CLLocation
}
class HotelListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var locationManager: CLLocationManager!
    var presenter: HotelListPresenter!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var nowLocation: CLLocation?
    var hotelImageUrl: String?
    
//    fileprivate func initializeLocationManager() {
//        locationManager = CLLocationManager()
//    }
//    
//    fileprivate func requestAuthorization() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//    
//    fileprivate func setupLocationManagerIfNeeded() {
//        let status = CLLocationManager.authorizationStatus()
//        if status == .authorizedWhenInUse || status == .authorizedAlways {
//            locationManager.delegate = self
//            locationManager.distanceFilter = 10
//            locationManager.startUpdatingLocation()
//        }
//    }

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
        fetchedLocation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetchedLocation() {
        presenter.goActivityIndicator()
        if nowLocation != nil {
           self.presenter.viewWillAppear(nowLocation: self.nowLocation!)
        } else {
            locationLoading()
        }
    }
    
    func locationLoading() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2.0) {
            self.fetchedLocation()
        }
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
        hotelImageUrl = presenter.hotelItem[indexPath.item].imageUrl
        presenter.toDetail(hotel: presenter.hotelItem[indexPath.row], restMin: presenter.hotelItem[indexPath.item].restMin, stayMin: presenter.hotelItem[indexPath.item].stayMin)
    }

}

extension HotelListViewController: HotelListView, NVActivityIndicatorViewable {
//    func location() -> CLLocation {
//        if nowLocation != nil {
//            return nowLocation!
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                return self.nowLocation
//            }
//        }
//        return nowLocation!
//    }
    
    
    func toDetail(hotel: HotelItem, restMin: Int, stayMin: Int) {
        let vc = HotelDetailViewController.instantiate(for: hotel)
        vc.hotelImageUrl = hotelImageUrl
        vc.restMin = restMin
        vc.stayMin = stayMin
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func reLoad() {
        collectionView.reloadData()
    }
    
    func presentActivityIndicator(message: String) {
        startAnimating(message: message)
    }
    
    func dismissActivityIndicator() {
        stopAnimating()
    }
    
    
}
//extension HotelListViewController: CLLocationManagerDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.first
//         latitude = location?.coordinate.latitude
//         longitude = location?.coordinate.longitude
//        nowLocation = location
//        print("nowwww\(nowLocation)")
//    }
//}
