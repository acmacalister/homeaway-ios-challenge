//
//  Addition.swift
//  HomeAway
//
//  Created by Austin Cherry on 8/14/17.
//  Copyright © 2017 Vluxe. All rights reserved.
//

import UIKit

class Additions {
    static let dateFormatter = DateFormatter()
    
    class func convertDate(date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateStyle = .full
        if let d = date {
            return  dateFormatter.string(from: d)
        }
        return ""
    }
}
