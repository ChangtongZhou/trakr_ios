//
//  PublicFuncs.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/20/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import Foundation
import UIKit

class PublicFuncs {
    static func showAlert(controller: UIViewController, title: String, detail: String) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: title, message: detail, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        })
    }
}