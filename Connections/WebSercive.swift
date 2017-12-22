//
//  WebSercive.swift
//
//  Created by Macbook on 10/10/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation


class WebService: NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    static let sharedInstance = WebService()
//    var crimeArray = [Crime]()
//    
//    //set the Base URL with the required filter.
//    let baseURL : NSURL = NSURL(string: "https://data.sfgov.org/resource/ritf-b9ki.json?$where=%20date='2015-12-01T00:00:00'%20and%20date%3C'2016-01-01T00:00:00'")!
//    
//    // MARK: - Utility Methods for API calls
//
//    func sendData(json:AnyObject?, method:String, url:NSURL, success:((_ json:AnyObject) -> Void)?, fail:((_ error: Error) -> Void)?) {
//        if("\(self.baseURL)" == "") {
//            fail?(NSError(domain: "Could not connect to the server", code: 400, userInfo: nil))
//            return
//        }
//        var postData:NSData?
//        do {
//            var urlRequest:NSMutableURLRequest?
//            if let checkedJson = json {
//                try postData = JSONSerialization.data(withJSONObject: checkedJson, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
//                urlRequest = NSMutableURLRequest(url: url as URL)
//                urlRequest!.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                urlRequest!.httpBody = postData as Data?
//                urlRequest!.setValue(String(postData!.length), forHTTPHeaderField: "Content-Length")
//            }
//            else {
//                urlRequest = NSMutableURLRequest(url: url as URL)
//            }
//            urlRequest?.httpMethod = method
//            
//            //send web request
//            let config = URLSessionConfiguration.default
//            let session = Foundation.URLSession(configuration:config,delegate: self, delegateQueue: .main)
//  
//            let task = session.dataTask(with: urlRequest! as URLRequest) { (data, response, error) -> Void in
//                //print("data here: \((data! as AnyObject))")
//                
//                if(error != nil) {
//                    print("data here: \(data)")
//                    fail?(error!)
//                    return
//                }
//                else {
//                    if(data != nil) {
//                        var json:AnyObject?
//                        do {
//                            
//                             json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
//                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
//                              success?(json! as AnyObject)
//                                //print("json here: \(json)")
//                            } else {
//                                success?((json! as AnyObject?)!)
//                            }
//                            
//                            
////                            try json = JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
////                            success?(json! as AnyObject)
//                        }
////                        catch {
////                            success?(data! as AnyObject)
////                        }
//                    }
//                    return()
//                }
//            }
//            task.resume()
//        }
//        catch {
//            
//        }
//    }
//    
//     private func URLSession(session: URLSession, task: URLSessionTask, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if(challenge.previousFailureCount == 0) {
//            if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//                let creds:URLCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//                completionHandler(.useCredential, creds)
//            }
//            else {
//                completionHandler(.performDefaultHandling, nil)
//                challenge.sender?.performDefaultHandling!(for: challenge)
//            }
//        }
//        else {
//            print("failed to authenticate")
//            completionHandler(.cancelAuthenticationChallenge, nil)
//        }
//    }
//    
//    private func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
//        completionHandler(.allow)
//    }
//    
}
    
    

