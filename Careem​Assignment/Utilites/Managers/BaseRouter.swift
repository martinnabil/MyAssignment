//
//  BaseRouter.swift
//  Careem​Assignment
//
//  Created by Hassan on 12/16/17.
//  Copyright © 2017 Hassan. All rights reserved.
//

import Foundation
import Alamofire

public typealias JSONDictionary = [String: AnyObject]
typealias APIParams = [String : AnyObject]?

protocol APIConfiguration
{
    var method: Alamofire.HTTPMethod { get set }
    var encoding: Alamofire.ParameterEncoding? { get }
    var query: String { get set }
    var page : String { get set }
    var baseURLString: String { get }
    var requestHeaders : [String : Any] { get set }
}

class BaseRouter : URLRequestConvertible, APIConfiguration
{
    
    var query: String
    var page : String
    
    var method: HTTPMethod

    var requestHeaders: [String : Any]

    init(method: HTTPMethod, query: String,page: String) {
        self.method = method
        self.query = query
        self.page = page
        self.requestHeaders = ["Content-Type" : "application/json"]
    }
    
    var encoding: ParameterEncoding?{
        return JSONEncoding.default
    }
    
    var baseURLString : String{
        return EnviromentManager.shared.BaseURL
    }
    
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest {

        let url = URL(string: baseURLString + "&query=\(query)&page=\(page)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        for (key,value) in requestHeaders
        {
            urlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }

        return urlRequest
    }

}
