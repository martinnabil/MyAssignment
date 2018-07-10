//
//  BaseNetworkManager.swift
//  Blabber
//
//  Created by Hassan on 12/16/17.
//  Copyright © 2017 Hassan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseNetworkManager : NSObject
{
    typealias SuccessCompletion = (Any) -> Void
    
    typealias FailureCompletion = (APIError) -> Void
    
    func performNetworkRequest(forRouter router: BaseRouter , onSuccess: @escaping SuccessCompletion , onFailure: @escaping FailureCompletion)
    {
//        print(self.JSONStringify(value: router.parameters as AnyObject, prettyPrinted: true))  // API parameters

        print(router.urlRequest?.allHTTPHeaderFields)
        
        Alamofire.request(router)
        
        .responseJSON { (response) in
            print(response.debugDescription)

            print(response.result)
            
            switch response.result {
            
            case .success( _):
                if let obj : [String : Any] = response.result.value as? [String : Any] {
                    if obj["results"] == nil {
                        let apiError = APIError()
                        apiError.message = (obj["status_message"] as! String)
                        return onFailure(apiError)
                    }
                }
                return onSuccess(response.result.value!)
                
                
            case .failure(_):
                let apiError = APIError()
                                
                if let error = response.result.error as? AFError
                {
                    apiError.responseStatusCode = error._code // statusCode private
                    
                    var localizedDescription : String?
                    var failureReason : String?
                    switch error
                    {
                        case .invalidURL(let url):
                            
                            localizedDescription = "Invalid URL: \(url) - \(error.localizedDescription)"
                            print("Invalid URL: \(url) - \(error.localizedDescription)")
                        
                        case .parameterEncodingFailed(let reason):
                            
                            localizedDescription = "Parameter encoding failed: \(error.localizedDescription)"
                            failureReason = "Failure Reason: \(reason)"
                            print("Parameter encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        
                        
                        case .multipartEncodingFailed(let reason):
                            localizedDescription = "Multipart encoding failed: \(error.localizedDescription)"
                            failureReason = "Failure Reason: \(reason)"
                            print("Multipart encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        
                        case .responseValidationFailed(let reason):
                            localizedDescription = "Response validation failed: \(error.localizedDescription)"
                            failureReason = "Failure Reason: \(reason)"
                            print("Response validation failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            
                            switch reason
                            {
                                case .dataFileNil, .dataFileReadFailed:
                                    localizedDescription = "Downloaded file could not be read"
                                    print("Downloaded file could not be read")
                                case .missingContentType(let acceptableContentTypes):
                                    localizedDescription = "Content Type Missing: \(acceptableContentTypes)"
                                    print("Content Type Missing: \(acceptableContentTypes)")
                                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                    localizedDescription = "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                                case .unacceptableStatusCode(let code):
                                    localizedDescription = "Response status code was unacceptable: \(code)"
                                    print("Response status code was unacceptable: \(code)")
                                    apiError.responseStatusCode = code
                            }
                        case .responseSerializationFailed(let reason):
                            localizedDescription = "Response serialization failed: \(error.localizedDescription)"
                            failureReason = "Failure Reason: \(reason)"
                            print("Response serialization failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        
                    }
                    
                    apiError.message = localizedDescription
                    apiError.extraDescription = failureReason
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
                
                print(response.result)
                print(response.result.error)

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
