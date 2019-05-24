//
//  FindLocationViewController.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 25/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class FindLocationViewController: UIViewController {

    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var mediaUrl: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
