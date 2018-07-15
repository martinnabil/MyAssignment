//
//  BaseNetworkManager.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/9/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//

import Foundation
import Alamofire

class BaseNetworkManager : NSObject
{
    typealias SuccessCompletion = (Any) -> Void
    
    typealias FailureCompletion = (APIError) -> Void
    
    func performNetworkRequest(forRouter router: BaseRouter , onSuccess: @escaping SuccessCompletion , onFailure: @escaping FailureCompletion)
    {
        
        Alamofire.request(router)
        
        .responseJSON { (response) in
            print(response.debugDescription)

            print(response.result)
            
            switch response.result {
            
            case .success( _):
                if let obj : [String : Any] = response.result.value as? [String : Any] {
                    if obj["results"] == nil {
                        let apiError = APIError()
                     //   apiError.message = (obj["status_message"] as! String)
                        return onFailure(apiError)
                    }
                }
                return onSuccess(response.result.value!)
                
                
            case .failure(_):
                let apiError = APIError()
                                
                if let error = response.result.error as? AFError
                {
                    apiError.responseStatusCode = error._code // statusCode private
  
                }
                else if let error = response.result.error as? URLError
                {
                    print("URLError occurred: \(error)")
                    apiError.error = error
                }
                else
                {
                    print("Unknown error: \(String(describing: response.result.error))")
                }

                return onFailure(apiError)
                
            }
            
        }
    }
    

    
    
    
    // MARK:- Helper
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
            catch {
                print("error")
            }
            
        }
        return ""
    }

}
