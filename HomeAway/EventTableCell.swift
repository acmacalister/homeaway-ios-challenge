//
//  EventTableCell.swift
//  HomeAway
//
//  Created by Austin Cherry on 8/14/17.
//  Copyright © 2017 Vluxe. All rights reserved.
//

import UIKit
import SnapKit

class EventTableCell: UITableViewCell {
    static let reuseIdentifier: String = "EventCell"
    
    let favoritedView = UIImageView()
    let imgView = UIImageView()
    let titleLabel = UILabel()
    let locationLabel = UILabel()
    let dateLabel =  UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        favoritedView.isHidden = true
        favoritedView.image = UIImage(named: "heart")
        
        imgView.layer.cornerRadius = 5
        imgView.layer.masksToBounds = true
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = .left

        locationLabel.textColor = UIColor.gray
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textAlignment = .left
        
        dateLabel.textColor = UIColor.gray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .left
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(90)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
        }
        
        addSubview(favoritedView)
        favoritedView.snp.makeConstraints { (make) in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.left.equalTo(self).offset(5)
            make.top.equalTo(self).offset(5)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        addSubview(locationLabel)
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
        }
    }
}
