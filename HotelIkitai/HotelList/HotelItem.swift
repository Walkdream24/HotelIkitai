//
//  HotelItem.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/07.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

struct HotelItem {
    let address: String
    let area: String
    let imageUrl: String
    let name: String
    let restMin: Int
    let stayMin: Int
    let docId: String
    let latitude: Double
    let longitude: Double
    let location: CLLocation
    let distance: Double
   
    
    init(from dict: [String:Any], docId: String, nowLocation: CLLocation) {
        address = dict["address"] as? String ?? ""
        area = dict["area"] as? String ?? ""
        imageUrl = dict["imageUrl"] as? String ?? ""
//        imageUrl = (dict["imageUrl"] as? String ?? "").flatMap {URL(string: $0)}
        name = dict["name"] as? String ?? ""
        restMin = dict["restMin"] as? Int ?? 1000000
        stayMin = dict["stayMin"] as? Int ?? 1000000
        latitude = dict["latitude"] as? Double ?? 0
        longitude = dict["longitude"] as? Double ?? 0
        location = CLLocation(latitude: latitude, longitude: longitude)
        distance = (round(location.distance(from: nowLocation)*10)/10)/1000
        self.docId = docId
       
    }
}

