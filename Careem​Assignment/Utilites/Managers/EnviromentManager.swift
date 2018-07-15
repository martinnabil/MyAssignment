//
//  EnviromentManager.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/9/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//

import Foundation
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
