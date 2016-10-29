//
//  TaskModel.swift
//  bucket_list
//
//  Created by Tianyu Ying on 7/20/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import Foundation

class WebOperation {
//    static func getAllTasks(completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()) {
//        let url = NSURL(string: "http://localhost:5000/tasks")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url!, completionHandler: completionHandler)
//        task.resume()
//    }
    
//    static let url = "localhost:5000"
    static let url = "54.200.84.0"
    
    static func signUpUser(info: UserSignUpInfo, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()) {
        if let urlToReq = NSURL(string: "http://\(url)/signup") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "name=\(info.userName!)&password=\(info.password!)&confirm_password=\(info.confirmPassword!)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func signInUser(info: UserSignInInfo, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()) {
        if let urlToReq = NSURL(string: "http://\(url)/signin") {
            print("http://\(url)/signin")
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "name=\(info.userName!)&password=\(info.password!)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func createNewRecord(info: Record, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()) {
        if let urlToReq = NSURL(string: "http://\(url)/addrecord") {
            print("http://\(url)/addrecord")
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "name=\(info.userName!)&title=\(info.title!)&memo=\(info.memo!)&latitude=\(info.latitude!)&longitude=\(info.longitude!)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func getAllRecordsByUser(userName: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()) {
        if let urlToReq = NSURL(string: "http://\(url)/getall") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "name=\(userName)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func deleteRecord(id: Int, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()) {
        if let urlToReq = NSURL(string: "http://\(url)/delete") {
            let request = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "id=\(id)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
            task.resume()
        }
    }
}