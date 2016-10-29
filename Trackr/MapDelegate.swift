//
//  MapDelegate.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/21/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import Foundation
import UIKit

protocol MapDelegate: class {
    func pinOnMap(controller: UIViewController, track: Track)
}