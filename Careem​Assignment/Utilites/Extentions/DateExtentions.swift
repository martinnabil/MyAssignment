//
//  DateExtentions.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/10/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringEn( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
}
