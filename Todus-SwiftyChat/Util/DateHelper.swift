//
//  DateHelper.swift
//  toDus-SwiftUI
//
//  Created by Wilder Lopez on 9/3/20.
//  Copyright © 2020 iGhost. All rights reserved.
//

import Foundation

class DateHelper{
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        //        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    ///Return short Time : 9:51 am
    static func getDateWith(timeInterval : Int64) -> String{
        let date = Date(milliseconds: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    //Return Specific pretty date Time
    static func getPrettyDateWith(timeInterval: Int64, dateFormat: String = "d MMM", dateStyle: DateFormatter.Style = .none , timeStyle : DateFormatter.Style = .none, relativeDate: Bool = false) -> String{
        
        let date = Date(milliseconds: timeInterval)
        let dateFormatter = DateFormatter()
        
        
        
        if Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date){
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.dateStyle = .short
        }else {
            dateFormatter.dateFormat = dateFormat
            dateFormatter.doesRelativeDateFormatting = relativeDate
            if dateStyle == .none {
                dateFormatter.dateStyle = dateStyle
            }
            if timeStyle == .none {
                dateFormatter.timeStyle = timeStyle
            }
        }
        
        return dateFormatter.string(from: date)
    }
    
    ///Return Custom String Date
    static func getCustomStringDateUsing(timeInterval ti: Int64, dateFormat: String, dateStyle: DateFormatter.Style = .none , timeStyle : DateFormatter.Style = .none, relativeDate: Bool = false) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(ti))
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_US")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.doesRelativeDateFormatting = relativeDate
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: date)
    }
    
    static func getDateWith(timeInterval : Int64) -> Date {
        let date = Date(milliseconds: timeInterval)
        return date
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
