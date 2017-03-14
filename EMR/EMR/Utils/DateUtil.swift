//
//  DateUtil.swift
//  EMR
//
//  Created by Akshay Bhandary on 10/14/16.
//  Copyright © 2016 AkshayBhandary. All rights reserved.
//

import Foundation

class DateUtil
{
    static func ageFromDate(date : NSDate) -> Int
    {
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let ageComponents = calendar.components(.Year, fromDate: date, toDate: NSDate(), options: .MatchFirst);
        let age = ageComponents.year
        return age;
    }
}
