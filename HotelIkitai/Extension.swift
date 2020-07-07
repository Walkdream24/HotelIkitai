//
//  Extension.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/02.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}
public extension UINavigationBar {
    /// ナビゲーションバーを透明化する
    func enableTransparency() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }

    /// ナビゲーションバーを透明化を解除する
    func disableTransparency() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
}
