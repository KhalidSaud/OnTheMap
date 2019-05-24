//
//  MapVC.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 20/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    private let manager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
//    var students : [Dummy] = []
    var students : [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
//        students = GetDummyData()
        API.GetAllStudentsFromAPI { (data, error) in
            if let data = data {
                self.students = data.studentsResult
                self.StudentsSetup()
            }
            if let error = error {
                print(error)
            }
        }
    }
    
    
    private func configureLocationServices() {
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Setup
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        toFind()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logOut()
    }

}


extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func setup() {
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self // This needed to add our custom images etc
        
        if let center = self.manager.location?.coordinate {
            
            // Region
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 20000, longitudinalMeters: 20000)
            mapView.setRegion(region, animated: false)
        }
    }
    
    
    
    func StudentsSetup() {
        var rand = 0.05
        
        if let center = self.manager.location?.coordinate {
            
            // Student Location
            var annoCoord = center
            for student in students {
                annoCoord.latitude = student.latitude
                annoCoord.longitude = student.longitude
                let anno = MKPointAnnotation()
                anno.title = student.firstName
                anno.subtitle = "\(student.mediaURL)"
                anno.coordinate = annoCoord
                self.mapView.addAnnotation(anno)
                rand += 0.05
            }
        }
    }
    
}


extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Title")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Title")
            annotationView?.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
            annotationView!.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "pin")
        
        if var frame = annotationView?.frame {
            frame.size.width = 45.0
            frame.size.height = 60.0
            annotationView?.frame = frame
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let urlString = view.annotation?.subtitle {
            guard let url = urlString else {
                return
            }
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
        
    }
    
}
