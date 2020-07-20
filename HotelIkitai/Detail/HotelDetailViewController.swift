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
import GoogleMobileAds
import WebKit

protocol HotelDetailView: class {
    func setUpDetailInfo()
    func presentActivityIndicator(message: String)
    func dismissActivityIndicator()
    func toHotelWebSite()
    func callAction()
}

class HotelDetailViewController: UIViewController, GADBannerViewDelegate {

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
    @IBOutlet weak var mediumBannerView: UIView!
    @IBOutlet weak var toMapAppButton: UIButton!
    var alertController: UIAlertController!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var presenter: HotelDetailPresenter!
    var hotelImageUrl: String?
    var restMin: Int = 0
    var stayMin: Int = 0
    var distance: Double = 0
    var gradientLayer: CAGradientLayer!
    var bannerView: GADBannerView!
    let myPin: MKPointAnnotation = MKPointAnnotation()
    
    static func instantiate(for hotel: HotelItem) -> HotelDetailViewController {
        let vc = R.storyboard.hotelDetail.hotelDetail()!
        vc.presenter = HotelDetailPresenter(view: vc, hotel: hotel)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer = CAGradientLayer()
        toMapAppButton.layer.cornerRadius = 4
        let location = CLLocationCoordinate2DMake(latitude!, longitude!)
        mapView.setCenter(location, animated:true)
        var region = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        // マップビューに縮尺を設定
        mapView.setRegion(region, animated:true)
        myPin.coordinate = location
        mapView.addAnnotation(myPin)
        admobTest()
        admobTest2()
    }
    
    func admobTest() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3343885117344222/5948871302"
        bannerView.rootViewController = self
        let request = GADRequest()
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["c1b7d6a29562e5694007f76016521714"]
        bannerView.load(request)
        bannerView.delegate = self
    }
    
    func admobTest2() {
        bannerView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        mediumBannerView.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-3343885117344222/5948871302"
        bannerView.rootViewController = self
        let request = GADRequest()
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["c1b7d6a29562e5694007f76016521714"]
        bannerView.load(request)
        bannerView.delegate = self
     }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: bottomLayoutGuide,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.black
//        navigationController?.navigationBar.enableTransparency()
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
//     func callAlert(title:String, message:String,completion: @escaping () -> Void) {
    func mapAlert(title:String, message:String) {
        alertController = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "Google Maps", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.presenter.toMapApp(latitude: self.latitude!, longitude: self.longitude!, googleMap: true)
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title: "マップ", style: UIAlertAction.Style.default, handler:{
                  (action: UIAlertAction!) -> Void in
            self.presenter.toMapApp(latitude: self.latitude!, longitude: self.longitude!, googleMap: false)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })

        alertController.addAction(defaultAction)
        alertController.addAction(defaultAction2)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func toMapAppButtonTapped(_ sender: Any) {
        mapAlert(title: "", message: "どの地図アプリで開きますか？")
    }
    @IBAction func hotelLinkTapped(_ sender: UIButton) {
        presenter.toHotelWebSite()
    }
    @IBAction func callButtonTapped(_ sender: UIButton) {
        presenter.toCall()
    }
    

}
extension HotelDetailViewController: HotelDetailView, NVActivityIndicatorViewable {
    func callAction() {
            let callString = self.presenter.item[0].callNumber.replacingOccurrences(of:"-", with:"")
            print("aaaaa\(callString)")
            let url = NSURL(string: "tel://\(callString)")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
    }
    
    func toHotelWebSite() {
        let vc = StaticWebViewController(url: URL(string: "\(presenter.item[0].hotelUrl)")!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
        let getDistance = "\(distance)".prefix(3)
        distanceLabel.text = "現在地から\(getDistance)km"
        addressLabel.text = presenter.item[0].address
        accessLabel.text = presenter.item[0].access
        roomNumLabel.text = "\(presenter.item[0].roomNum)室"
        restPlanLabel.text = presenter.item[0].restPlan
        stayPlanLabel.text = presenter.item[0].stayPlan
        hotelUrlLabel.text = presenter.item[0].hotelUrl
        callNumLabel.text = "\(presenter.item[0].callNumber)"
        myPin.title = presenter.item[0].name
        self.navigationItem.title = presenter.item[0].name
    }
}

