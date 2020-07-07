//
//  HomeModel.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/01.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import CoreLocation

protocol HomeModelDelegate: class {
    func fetchedLocation(placeName: String, with error: Error?)
}

class HomeModel {
    weak var delegate: HomeModelDelegate?

    func getPlaceName(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let firstPlacemark = placemarks?.first {
                var placeName = ""
                if let administrativeArea = firstPlacemark.administrativeArea {
                    placeName.append(administrativeArea)
                }
                if let locality = firstPlacemark.locality {
                    placeName.append(locality)
                }
                if let thoroughfare = firstPlacemark.thoroughfare {
                    placeName.append(thoroughfare)
                } else if let subLocality = firstPlacemark.subLocality {
                    placeName.append(subLocality)
                }
                self.delegate?.fetchedLocation(placeName: placeName, with: error)
            } else {
                print("nothing")
            }
        }
    }
    
}
