//
//  extenstions.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 24/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        
        return ai
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func toFind() {
        performSegue(withIdentifier: "ToFind", sender: nil)
    }
    
    func logOut() {
        API.DeleteSession { (response, error) in
            
            if error != nil {
                print(error!)
            }
            
            guard let response = response else {
                print("log out not success")
                print(error!)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            print("log out success")
            print(response)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
}
