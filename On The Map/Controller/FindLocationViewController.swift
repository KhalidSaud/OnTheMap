//
//  FindLocationViewController.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 25/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {

    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var mediaUrl: UITextField!
    
    var savedLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func findLocationButtonPressed(_ sender: Any) {
        guard let cityName = cityName else {
            return
        }
        guard let mediaUrl = mediaUrl else {
            return
        }
        if (cityName.text != "" || cityName.text?.isEmpty == false) && (mediaUrl.text != "" || mediaUrl.text?.isEmpty == false) {
            forwardGeocoding(address: cityName.text!)
        } else {
            print("No values provided")
            showAlert(title: "Error", message: "Please fill the text fields")
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func forwardGeocoding(address: String) {
        let indicator = startAnActivityIndicator()
        indicator.startAnimating()
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    indicator.startAnimating()
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
                return
            }
            
            guard let placemarks = placemarks else {
                return
            }
            
            if placemarks.count > 0 {
                let placemark = placemarks[0]
                if let location = placemark.location {
                    let coordinate = location.coordinate
                    DispatchQueue.main.async {
                        indicator.startAnimating()
                    }
                    self.savedLocation = coordinate
                    print("address for: \(address), lat: \(coordinate.latitude), long: \(coordinate.longitude)")
                    self.performSegue(withIdentifier: "toConfirmation", sender: nil)
                }
            } else {
                print("no place found")
                DispatchQueue.main.async {
                    indicator.stopAnimating()
                    self.showAlert(title: "Error", message: "Place not found!")
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmation" {
            if let confirmationVC = segue.destination as? ConfirmLocationViewController {
                confirmationVC.location = savedLocation
                confirmationVC.city = cityName.text ?? ""
                confirmationVC.mediaUrl = mediaUrl.text ?? ""
            }
        }
    }
    
}
