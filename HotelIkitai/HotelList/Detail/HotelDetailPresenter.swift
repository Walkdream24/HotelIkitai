//
//  HotelDetailPresenter.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/09.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation

class HotelDetailPresenter {
    
    private let model: HotelDetailModel
    private weak var view: HotelDetailView!
    var item: [HotelDetailItem] {return model.items}
    var hotel: HotelItem
    
    init(view: HotelDetailView, hotel: HotelItem) {
        self.model = HotelDetailModel()
        self.view = view
        self.hotel = hotel
        self.model.delegate = self
        model.fetchHotelDetail(with: hotel.docId)
    }
}
extension HotelDetailPresenter: HotelDetailModelDelegate {
    func didFetchHotelDetail(with error: Error?) {
        if error != nil {
            print(error?.localizedDescription)
        } else {
            view.setUpDetailInfo()
        }
    }
}
