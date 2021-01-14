//
//  GithubNetworkOperation.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/14.
//

import UIKit
import Alamofire

/**
    This class implements all network operation to Github
 
    It is a singleton object, you could use `GithubNetworkOperation.shared` to access this singleton object
 */
class GithubNetworkOperation: NSObject {
    // singleton object
    public static let shared: GithubNetworkOperation = GithubNetworkOperation()

    // prevent from generating object except `shared`
    private override init() {
        super.init()
    }

    // Endpoint URL for github
    private let endpoint: String = "/"
    
    
}

// MARK: Operaion
extension GithubNetworkOperation {
    /// Get the data from endpoint
    ///
    /// - parameter completionHandler: Callback method when the requeis is completed. there are two paramters in callback, if success, result will be nill, and response is stored the result.
    ///
    /// - returns: The created `Request`.
    
    @discardableResult
    func visitEndpoint(completionHandler: @escaping (_ result : Error?, _ response: [String : Any]?) -> Void ) -> Request? {
        load(path: endpoint, completionHandler: completionHandler)
    }
}

// MARK: Generic Operaion
extension GithubNetworkOperation {
    /// convenient method for Alamofire request method.
    /// get data from `path` by GET HTTP method, and convert the data  to [String: Any] type value.
    ///
    /// - parameter path:       only path, URL = base url + path, base url specified by ` baseURL` property of `Envieronemnt`
    /// - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter completionHandler: Callback method when the requeis is completed. there are two paramters in callback, if success, result will be nill, and response is stored the result.
    ///
    /// - returns: The created `Request`.
    
    @discardableResult
    func load(path : String, encoding: ParameterEncoding = URLEncoding.default,
              parameters : Parameters? = nil,
              completionHandler: @escaping (_ result : Error?, _ response: [String : Any]?) -> Void) -> Request? {
        
        let url = ENV.baseURL + path;
        return Alamofire.request(url, method: .get,
                                 parameters: parameters,
                                 encoding: encoding)
            .responseJSON { response in
                guard response.error == nil else {
                    completionHandler(response.error, nil)
                    return
                }

                guard response.response != nil, response.response!.statusCode == 200 else {
                    let error = NSError(domain: ErrorDomain,
                                        code: OPERATION_INVALID_STATUS_CODE,
                                        userInfo: [
                                            "message" : "Invalid status code"
                                        ])
                    completionHandler(error, nil)
                    return ;
                }
                
                guard let dic = response.result.value as? [String : Any] else {
                    let error = NSError(domain: ErrorDomain,
                                        code: OPERATION_FAIL_INVALID_FEEDBACK,
                                        userInfo: [
                                            "message" : "Invalid feedback"
                                        ])
                    completionHandler(error, nil)
                    return ;
                }

                DispatchQueue.global().async {
                    completionHandler(nil, dic)
                }
            }
    }
}
