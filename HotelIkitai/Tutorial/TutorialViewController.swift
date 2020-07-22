//
//  TutorialViewController.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/22.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import CoreLocation

class TutorialViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tutorialLabel: UILabel!
    var locationManager: CLLocationManager!
    fileprivate func initializeLocationManager() {
         locationManager = CLLocationManager()
     }
     
     fileprivate func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        self.locationManager.delegate = self
        nextButton.layer.cornerRadius = nextButton.frame.height / 2 
    }
    override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(true)
             navigationController?.setNavigationBarHidden(true, animated: false)
    }
 
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        requestAuthorization()
    }
}
extension TutorialViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("未設定")
        case .authorizedAlways:
            print("常に")
            let vc = R.storyboard.home.home()!
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        case .authorizedWhenInUse:
            print("使用時のみ")
            let vc = R.storyboard.home.home()!
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        case .denied:
            print("拒否")
            let vc = R.storyboard.home.home()!
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        case .restricted:
            print("機能制限")
            let vc = R.storyboard.home.home()!
            self.navigationController?.pushViewController(vc, animated: true)
            UserDefaults.standard.set(false, forKey: "firstLaunch")
        }
    }
}
