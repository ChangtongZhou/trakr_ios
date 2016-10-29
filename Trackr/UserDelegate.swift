//
//  UserDelegate.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/20/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import Foundation
import UIKit

protocol UserDelegate: class {
    
    func userSignUp(controller: UIViewController)
    
    func userSignOff(controller: UIViewController)
    
}