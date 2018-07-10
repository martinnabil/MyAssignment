//
//  MovieModel.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/9/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//


import UIKit
import ObjectMapper

struct MovieModel: Mappable {
    
    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [Results]?
    

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        page <- map["page"]
        total_results <- map["total_results"]
        total_pages <- map["total_pages"]
        results <- map["results"]

    }
}



struct Results: Mappable {
   
    var title : String?
    var overview : String?
    var poster_path : String?
    var release_date : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        overview <- map["overview"]
        poster_path <- map["poster_path"]
        release_date <- map["release_date"]
      
        
    }
}







