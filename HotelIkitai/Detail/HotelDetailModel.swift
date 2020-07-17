//
//  HotelDetailModel.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/09.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import Firebase

protocol HotelDetailModelDelegate : class {
    func didFetchHotelDetail(with error: Error?)
}
class HotelDetailModel {
    var items = [HotelDetailItem]()
    weak var delegate: HotelDetailModelDelegate?
    
    func fetchHotelDetail(with hotelId: String) {
        let query = Firestore.firestore().collection("HotelDetail").whereField("hotelId", isEqualTo: hotelId)
        query.getDocuments { [weak self] (snapshot, error) in
            guard let `self` = self else { return }
            if let snapshot = snapshot {
                self.items = snapshot.documents.map {HotelDetailItem(from: $0.data(), docId: $0.documentID)}
            }
            self.delegate?.didFetchHotelDetail(with: error)
        }
    }
    func toMapApp(latitude: Double, longitude: Double, googleMap: Bool) {
        let urlString: String!
        if googleMap {
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                urlString = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=walking&zoom=14"
            } else {
                urlString = "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=w"
            }
        } else {
            urlString = "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=w"
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
}
