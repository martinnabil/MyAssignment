//
//  APIError.swift
//  Blabber
//
//  Created by Hassan on 12/16/17.
//  Copyright © 2017 Hassan. All rights reserved.
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
