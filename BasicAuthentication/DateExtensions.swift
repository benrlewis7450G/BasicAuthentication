//
//  DateExtensions.swift
//  hailculator
//
//  Created by Benjamin Lewis on 5/12/20.
//  Copyright © 2020 PDR Resources. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum DateFormats{
    case ymDhms
    case ymDhm
    case ymd
}

extension NSDate {
    func toFormatted(_ format:String?)->String{
        let df = DateFormatter.init()
        if(format?.count > 0){
            df.dateFormat = format
        }else{
            df.dateFormat = "yyyy-MM-dd HH:mm"
        }
        return df.string(from: self as Date)
            
    }
    func toFormatted(_ format:DateFormats)->String{
        let df = DateFormatter.init()
        switch format {
        case .ymDhms:
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            break
        case .ymd:
            df.dateFormat = "yyyy-MM-dd"
            break
        case .ymDhm:
            df.dateFormat = "yyyy-MM-dd HH:mm"
            break
        }
        return df.string(from: self as Date)
    }
}

extension Date {
    func toFormatted(_ format:String?)->String{
        let df = DateFormatter.init()
        if(format?.count > 0){
            df.dateFormat = format
        }else{
            df.dateFormat = "yyyy-MM-dd HH:mm"
        }
        return df.string(from: self)
        
    }
    func toFormatted(_ format:DateFormats)->String{
        let df = DateFormatter.init()
        switch format {
        case .ymDhms:
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            break
        case .ymd:
            df.dateFormat = "yyyy-MM-dd"
            break
        case .ymDhm:
            df.dateFormat = "yyyy-MM-dd HH:mm"
            break
        }
        return df.string(from: self)
    }
}

