//
//  ViewController.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/19/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import UIKit
import MapKit
import CoreData

struct UserSignInInfo {
    var userName: String?
    var password: String?
}

class SignInViewController: UIViewController, UserDelegate {

    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var users = [User]()
    
    var currUser: User?
    
    var errorMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        //37.377043, -121.914277
//        let record = Record(userName: "nick", title: "Car", memo: "My car", latitude: 37.377043, longitude: -121.914277)
//        
//        WebOperation.createNewRecord(record) {
//            data, response, error in
//            do {
//                if data != nil {
//                    if let res = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
//                        if let rst = res["rst"] as? NSDictionary {
//                            if let status = rst["status"] as? String {
//                                print(status)
//                            }
//                        }
//                    }
//                }
//            }
//            catch {
//                print("Something went wrong")
//            }
//        }
        
        textUserName.placeholder = "Username"
        textPassword.placeholder = "Password"
        
        resetTextFields()
        
        btnSignIn.layer.cornerRadius = 6.0
        
        fetchAllLocalUsers()
        
        for user in users {
            if let isLogin = user.isLogin {
                if isLogin != 0 {
                    currUser = user
                    break
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if currUser != nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    func userSignOff(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        
        currUser?.isLogin = 0
        saveChange()
        
        currUser = nil
        
        resetTextFields()
    }
    
    func userSignUp(controller: UIViewController) {
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func logInBtnPressed(sender: UIButton) {
        
        let userInfo = UserSignInInfo(userName: textUserName.text, password: textPassword.text)
        
        WebOperation.signInUser(userInfo) {
            data, response, error in
            do {
                if data != nil {
                    if let res = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        if let rst = res["rst"] as? NSDictionary {
                            if let status = rst["status"] as? String {
                                if status == "Success" {
                                    self.saveCurrUser(self.textUserName.text!)
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.performSegueWithIdentifier("LoginSegue", sender: self)
                                    })
                                }
                                else {
                                    if let err = rst["error"] as? String {
                                        PublicFuncs.showAlert(self, title: "Sign In", detail: err)
                                    }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue Outside")
        if segue.identifier == "LoginSegue" {
            print("Segue Inside")
            let navController =  segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! MapViewController
            controller.userDelegate = self
            controller.userName = currUser?.name
        }
        else if segue.identifier == "RegisterSegue" {
            let controller = segue.destinationViewController as! SignUpViewController
            controller.userDelegate = self
        }
    }
    
    func fetchAllLocalUsers() {

        let userRequest = NSFetchRequest(entityName: "User")
        
        do {
            let result = try managedObjectContext.executeFetchRequest(userRequest)
            users = result as! [User]
        }
        catch {
            print("\(error)")
        }
    }
    
    func resetTextFields() {
        textUserName.text = ""
        textPassword.text = ""
    }
    
    func saveCurrUser(name: String) {
        var userFound: User?
        for user in users {
            if user.name == name {
                userFound = user
                break
            }
        }
        
        if userFound == nil {
            let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
            userFound = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as? User
            userFound?.name = name
        }
        userFound?.isLogin = 1
        
        saveChange()
        
        currUser = userFound
    }
    
    func saveChange() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
            }
            catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

