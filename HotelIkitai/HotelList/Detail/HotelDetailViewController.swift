//
//  HotelDetailViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/03.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import MapKit
class HotelDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
//    var latitude: CLLocationDegrees?
//    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let latitude = 35.71427693160305
        let longitude = 139.57190515164064
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.setCenter(location, animated:true)
        var region = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        // マップビューに縮尺を設定
        mapView.setRegion(region, animated:true)
        var myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.title = "山桜ヒルズ"
        myPin.subtitle = "203号"
        myPin.coordinate = location
        mapView.addAnnotation(myPin)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.enableTransparency()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.disableTransparency()
    }


    

}
