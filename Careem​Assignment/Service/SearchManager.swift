//
//  SearchManager.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/9/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchManager: BaseNetworkManager {

    static var shared = SearchManager()
    
    func searchBusiness(basicDictionary query:String,page :String , onSuccess: @escaping (MovieModel)->Void, onFailure: @escaping  (APIError)->Void)
    {
        let engagementRouter = BaseRouter(method: .get, query: query, page: page)
        super.performNetworkRequest(forRouter: engagementRouter, onSuccess: { (responseObject) in
            let wrapper = Mapper<MovieModel>().map(JSON: responseObject as! [String : Any])
            onSuccess(wrapper!)
        }) { (apiError) in
            onFailure(apiError)
        }
    }

}
