//
//  HotelDetailViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/03.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView
import Nuke

protocol HotelDetailView: class {
    func setUpDetailInfo()
    func presentActivityIndicator(message: String)
    func dismissActivityIndicator()
}

class HotelDetailViewController: UIViewController {

    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var restMinLabel: UILabel!
    @IBOutlet weak var stayMinLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var roomNumLabel: UILabel!
    @IBOutlet weak var restPlanLabel: UILabel!
    @IBOutlet weak var stayPlanLabel: UILabel!
    @IBOutlet weak var hotelUrlLabel: UILabel!
    @IBOutlet weak var callNumLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
//    var latitude: CLLocationDegrees?
//    var longitude: CLLocationDegrees?
    var presenter: HotelDetailPresenter!
    var hotelImageUrl: String?
    var restMin: Int = 0
    var stayMin: Int = 0
    var gradientLayer: CAGradientLayer!
    
    static func instantiate(for hotel: HotelItem) -> HotelDetailViewController {
        let vc = R.storyboard.hotelDetail.hotelDetail()!
        vc.presenter = HotelDetailPresenter(view: vc, hotel: hotel)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer = CAGradientLayer()
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setShadow()
    }
    
    func setShadow() {
        gradientLayer.frame.size = self.hotelImageView.frame.size
        let color1 = UIColor.clear.cgColor
        let color2 = UIColor(hex: "000000", alpha: 0.55).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1 )
        hotelImageView.layer.insertSublayer(gradientLayer,at:0)
    }

}
extension HotelDetailViewController: HotelDetailView, NVActivityIndicatorViewable {
    func presentActivityIndicator(message: String) {
        startAnimating(message: message)
    }
    
    func dismissActivityIndicator() {
        stopAnimating()
    }
    
    func setUpDetailInfo() {
        if let url = URL(string: hotelImageUrl!) {
            Nuke.loadImage(with: url, into: hotelImageView)
        }
        hotelNameLabel.text = presenter.item[0].name
        restMinLabel.text = "¥\(restMin)"
        stayMinLabel.text = "¥\(stayMin)"
        addressLabel.text = presenter.item[0].address
        accessLabel.text = presenter.item[0].access
        roomNumLabel.text = "\(presenter.item[0].roomNum)室"
        restPlanLabel.text = presenter.item[0].restPlan
        stayPlanLabel.text = presenter.item[0].stayPlan
        hotelUrlLabel.text = presenter.item[0].hotelUrl
        callNumLabel.text = "\(presenter.item[0].callNumber)"
    }
}
