//
//  HotelDetailItem.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/09.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation


struct HotelDetailItem {
    let name: String
    let address: String
    let access: String
    let callNumber: String
    let hotelUrl: String
    let roomNum: Int
    let imageUrlList: String
    let restPlan: String
    let stayPlan: String
    let hotelId: String
    let docId: String
    
    init(from dict: [String:Any], docId: String) {
        name = dict["name"] as? String ?? ""
        address = dict["address"] as? String ?? ""
        access = dict["access"] as? String ?? ""
        callNumber = dict["callNumber"] as? String ?? ""
        hotelUrl = dict["hotelUrl"] as? String ?? ""
        roomNum = dict["roomNum"] as? Int ?? 0
        imageUrlList = dict["imageUrlList"] as? String ?? ""
        restPlan = dict["restPlan"] as? String ?? ""
        stayPlan = dict["stayPlan"] as? String ?? ""
        hotelId = dict["hotelId"] as? String ?? ""
        self.docId = docId
    }
    
}
