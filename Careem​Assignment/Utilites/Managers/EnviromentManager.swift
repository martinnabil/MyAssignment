//
//  EnviromentManager.swift
//  Blabber
//
//  Created by Hassan on 12/16/17.
//  Copyright © 2017 Hassan. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation

@objc public enum EnviromentType : Int{
    case StagingEnviroment
    case ProductionEnviromentMaster
}



class EnviromentManager
{
    private var currentEnviroment : EnviromentType = .ProductionEnviromentMaster
    static var shared = EnviromentManager()
    
    var BaseURL : String {
        get{
            switch self.currentEnviroment
            {
            case .StagingEnviroment:
                return ""
            case .ProductionEnviromentMaster:
                return "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838"
            }
        }
    }
    
    var imagesUrl = "http://image.tmdb.org/t/p/w92"

    
    class func intialize(enviroment:EnviromentType) {
        shared.currentEnviroment = enviroment
    }
    

    

    


    
}
