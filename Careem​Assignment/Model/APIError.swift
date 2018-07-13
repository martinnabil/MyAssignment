//
//  APIError.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/9/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//

import Foundation

class APIError: NSObject
{
    private var privateMessage: String? = "an error has occurred. Please try again."

    var message : String? {
        set {
            if let msg: String = newValue, msg.count > 0 {
                privateMessage = msg
            }
        }
        get {
            return privateMessage
        }
    }
    var extraDescription : String?
    var responseStatusCode : Int?
    var response : Any?
    var error : Error?
}
