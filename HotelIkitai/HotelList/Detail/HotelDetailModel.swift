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
    
}
