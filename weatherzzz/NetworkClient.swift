//
//  NetworkClient.swift
//  weatherzzz
//
//  Created by James Gibbons on 11/24/19.
//  Copyright © 2019 James Gibbons. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkClient {
    
    typealias WebServiceResponse = (JSON?, Error?) -> Void
    
    func fetch(_ url: URL, completion: @escaping WebServiceResponse) {
        Alamofire.request(url).validate().responseJSON { (responseData) -> Void in
            if let error = responseData.error {
                completion(nil, error)
            }
            else {
                if(responseData.result.value != nil) {
                    let swiftyJsonArray = JSON(responseData.result.value!)
                    completion(swiftyJsonArray, nil)
                }
            }
        }
    }
}
