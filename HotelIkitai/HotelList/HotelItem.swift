//
//  HotelItem.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/07.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import Firebase

struct HotelItem {
    let address: String
    let area: String
    let imageUrl: String
    let name: String
    let restMin: Int
    let stayMin: Int
    let docId: String
    
    init(from dict: [String:Any], docId: String) {
        address = dict["address"] as? String ?? ""
        area = dict["area"] as? String ?? ""
        imageUrl = dict["imageUrl"] as? String ?? ""
//        imageUrl = (dict["imageUrl"] as? String ?? "").flatMap {URL(string: $0)}
        name = dict["name"] as? String ?? ""
        restMin = dict["restMin"] as? Int ?? 1000000
        stayMin = dict["stayMin"] as? Int ?? 1000000
        self.docId = docId
    }
}
