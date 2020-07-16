//
//  HomeController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/01.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView
import CoreLocation

protocol HomeView: class {
    func updateLocation(placeName: String)
    func locationBool()
    
}
class HomeController: ButtonBarPagerTabStripViewController{

    @IBOutlet weak var fieldFrameView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var presenter: HomePresenter!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var nowLocation: CLLocation?
    var getLocationBool = false
    
    fileprivate func initializeLocationManager() {
        locationManager = CLLocationManager()
    }
    
    fileprivate func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    fileprivate func setupLocationManagerIfNeeded() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .clear
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarMinimumLineSpacing = 11
        settings.style.buttonBarRightContentInset = 150
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                    guard changeCurrentIndex else { return }
                    
            oldCell?.backgroundColor = UIColor(hex: "F5F5F5")
            oldCell?.layer.cornerRadius = (oldCell?.frame.height)! / 2
            newCell?.backgroundColor = UIColor.black
            newCell?.layer.cornerRadius = (newCell?.frame.height)! / 2
            oldCell?.label.textColor = .black
             oldCell?.label.font = .boldSystemFont(ofSize: 15)
             newCell?.label.textColor = .white
             newCell?.label.font = .boldSystemFont(ofSize: 15)
         }

        super.viewDidLoad()
        presenter = HomePresenter(view: self)
        fieldFrameView.layer.cornerRadius = 6
        initializeLocationManager()
        requestAuthorization()
        setupLocationManagerIfNeeded()
     
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        //のちにpresenter
        let searchVC = R.storyboard.search.search()!
//        let searchNav = UINavigationController(rootViewController: searchVC)
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.modalTransitionStyle = .crossDissolve
        present(searchVC, animated: true, completion: nil)
        
    }
    func giveLocation(vc: HotelListViewController) {
    
        if nowLocation != nil {
            vc.nowLocation = nowLocation
        } else {
            locationLoading(vc: vc)
        }
    }
    
    func locationLoading(vc: HotelListViewController) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
            self.giveLocation(vc: vc)
        }
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let reasonableList = HotelListViewController.instantiate(forType: .reasonable)
        let nearList = HotelListViewController.instantiate(forType: .near)
        giveLocation(vc: nearList)
        locationLoading(vc: nearList)
        giveLocation(vc: reasonableList)
        locationLoading(vc: reasonableList)
        return [nearList, reasonableList]
    }

}
extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocationBool = false
        let location = locations.first
         latitude = location?.coordinate.latitude
         longitude = location?.coordinate.longitude
        nowLocation = location
        presenter.fetchLocation(location: location!)
    }
}
extension HomeController: HomeView {
    func locationBool() {
        getLocationBool = true
    }
    
    func updateLocation(placeName: String) {
        locationLabel.text = placeName
    }
    
}

