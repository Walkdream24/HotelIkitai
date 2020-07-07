//
//  HotelListCollectionViewCell.swift
//  HotelIkitai
//
//  Created by 中重歩夢 on 2020/07/02.
//  Copyright © 2020 Ayumu Nakashige. All rights reserved.
//

import UIKit
import Nuke

class HotelListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var restMinLabel: UILabel!
    @IBOutlet weak var stayMinLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    var gradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hotelImageView.layer.cornerRadius = 14
        shadowView.layer.cornerRadius = 14
        gradientLayer = CAGradientLayer()
        shadowView.layer.addSublayer(gradientLayer)

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame.size = self.hotelImageView.frame.size
             let color1 = UIColor.clear.cgColor
             let color2 = UIColor(hex: "000000", alpha: 0.55).cgColor
             gradientLayer.colors = [color1, color2]
             gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
             gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1 )
             hotelImageView.layer.insertSublayer(gradientLayer,at:0)
        
    }
    func configure(with hotelItem: HotelItem) {
        if let url = URL(string: hotelItem.imageUrl) {
            Nuke.loadImage(with: url, into: hotelImageView)
        }
        hotelNameLabel.text = hotelItem.name
        restMinLabel.text = "¥\(hotelItem.restMin)"
        stayMinLabel.text = "¥\(hotelItem.stayMin)"
        areaLabel.text = hotelItem.area
    }
    

}
