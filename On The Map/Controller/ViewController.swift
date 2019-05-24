//
//  ViewController.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 20/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if (email.text != "" || email.text != nil) && (password.text != "" || password.text != nil) {
            login(email: email.text!, password: password.text!)
        } else {
            showAlert(title: "Login Failed", message: "Please fill your email and password")
        }
        
        
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)

    }
    
    func login(email: String, password: String) {
        API.GetSession(email: email, password: password) { (response, error) in
           
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.showAlert(title: "Login Failed", message: "Wrong Email or Password")
                }
                return
            }
            guard let response = response else {
                return
            }
            
            UserData.userId = response.account.key
            
            API.getUserData(userKey: UserData.userId, completion: { (response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                guard let response = response else {
                    return
                }
                
                UserData.firstName = response.firstName
                UserData.lastName = response.lastName
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ToMainScreen", sender: nil)
                }
                
            })
            
            
            
        
        }
    }
}

