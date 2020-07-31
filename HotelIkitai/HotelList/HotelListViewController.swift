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
    func toDetail(hotel: HotelItem, restMin: Int, stayMin: Int, latitude: Double, longitude: Double, distance: Double)
    func reLoad()
//    func location() -> CLLocation
}
class HotelListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: HotelListPresenter!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var nowLocation: CLLocation?
    var hotelImageUrl: String?
    let status = CLLocationManager.authorizationStatus()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:self.view.frame.width - 40, height:(self.view.frame.width - 40) * 0.95)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.hotelListCollectionViewCell)
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            fetchedLocation()
        } else {
            presentAlert()
            nowLocation = CLLocation(latitude: 35.6809591, longitude: 139.7673068)
            fetchedLocation()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if !(status == .authorizedWhenInUse || status == .authorizedAlways) {
//            presentAlert()
//        }
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
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) {
            self.fetchedLocation()
        }
    }
    func presentAlert() {
             let alert: UIAlertController = UIAlertController(title: "位置情報の許可お願いします", message: "位置情報の許可が認められないと近くのホテルを表示できません🥺\nデフォルトで東京駅になってます...", preferredStyle:  UIAlertController.Style.alert)
             
             let defaultAction: UIAlertAction = UIAlertAction(title: "設定画面へ", style: UIAlertAction.Style.default, handler:{
                 (action: UIAlertAction!) -> Void in
                 print("OK")
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
             })
             // キャンセルボタン
             let cancelAction: UIAlertAction = UIAlertAction(title: "あとで", style: UIAlertAction.Style.cancel, handler:{
                 (action: UIAlertAction!) -> Void in
                 print("Cancel")
             })
             alert.addAction(cancelAction)
             alert.addAction(defaultAction)
             present(alert, animated: true)
         
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
        presenter.toDetail(hotel: presenter.hotelItem[indexPath.row], restMin: presenter.hotelItem[indexPath.row].restMin, stayMin: presenter.hotelItem[indexPath.row].stayMin, latitude: presenter.hotelItem[indexPath.row].latitude, longitude: presenter.hotelItem[indexPath.row].longitude, distance: presenter.hotelItem[indexPath.row].distance)
    }

}

extension HotelListViewController: HotelListView, NVActivityIndicatorViewable {
    
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
        collectionView.reloadData()
    }
    
    func presentActivityIndicator(message: String) {
        startAnimating(message: message)
    }
    
    func dismissActivityIndicator() {
        stopAnimating()
    }
    
    
}

