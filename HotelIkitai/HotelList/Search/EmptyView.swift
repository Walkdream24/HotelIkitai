//
//  EmptyView.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/02.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    static func instantiate() -> EmptyView {
        let view = R.nib.emptyView.firstView(owner: nil)!
        return view
    }



}
