//
//  ViewController.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/19/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import UIKit
import MapKit

struct UserSignUpInfo {
    var userName: String?
    var password: String?
    var confirmPassword: String?
}

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textConfirmPassword: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    var userDelegate: UserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textUserName.placeholder = "Username"
        textPassword.placeholder = "Password"
        textConfirmPassword.placeholder = "Confirm Password"
        
        btnRegister.layer.cornerRadius = 6.0
    }
    
    @IBAction func registerBtnPressed(sender: UIButton) {
        
        print("pressed")
        
        let userInfo = UserSignUpInfo(userName: textUserName.text, password: textPassword.text, confirmPassword: textConfirmPassword.text)
        
        WebOperation.signUpUser(userInfo) {
            data, response, error in
            do {
                print("before get data")
                if let data = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    print("get data")
                    print(data)
                    
                    var errMsg = ""
                    
                    if let rst = data["rst"] as? NSDictionary {
                        print(rst)
                        if let status = rst["status"] as? String {
                            print(status)
                            if status == "Success" {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.userDelegate?.userSignUp(self)
                                })
                            }
                            else {
                                if let err = rst["error"] as? String {
                                    print(err)
                                    errMsg = err
                                    PublicFuncs.showAlert(self, title: "Sign Up", detail: errMsg)
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("Something went wrong")
            }
        }
    }
}

