
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    private let manager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    var location = CLLocationCoordinate2D()
    var city = ""
    var mediaUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        
        if !UserData.hasPost {
            postNewLocation(userId: UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName, city: city, mediaURL: mediaUrl, location: location)
        } else {
            PutYourLocation(userId: UserData.userId, firstName: UserData.firstName, lastName: UserData.lastName, city: city, mediaURL: mediaUrl, location: location)
        }
        
//        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func postNewLocation(userId: String, firstName: String, lastName: String, city: String, mediaURL: String, location: CLLocationCoordinate2D) {
        
        API.PostNewLocation(userId: userId, firstName: firstName, lastName: lastName, city: city, mediaURL: mediaURL, location: location) { (response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
            
            if response != nil {
                DispatchQueue.main.async {
                    UserData.postId = response!.objectID
                    print(UserData.postId)
                    self.showAlert(title: "Success", message: "Your location is successfully added")
                }
            }
            
        }
        
    }
    
    func PutYourLocation(userId: String, firstName: String, lastName: String, city: String, mediaURL: String, location: CLLocationCoordinate2D) {
        
        API.PutYourLocation(userId: userId, firstName: firstName, lastName: lastName, city: city, mediaURL: mediaURL, location: location) { (response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
            }
            
            if response != nil {
                DispatchQueue.main.async {
                    self.showAlert(title: "Success", message: "Your location is successfully updated")
                }
            }
            
        }
        
    }
    
    private func configureLocationServices() {
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Setup
            setup()
            findLocation(coord: location)
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func setup() {
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self // This needed to add our custom images etc
    }
    
    func findLocation(coord: CLLocationCoordinate2D) {
//        let coord = CLLocationCoordinate2D(latitude: -22.8983372, longitude: 17.0938797)
        // City Location
        let anno = MKPointAnnotation()
        anno.title = "\(UserData.firstName) \(UserData.lastName)"
        anno.subtitle = mediaUrl
        anno.coordinate = coord
        self.mapView.addAnnotation(anno)
        
        
        
        // Region
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: false)
    }
    
    // MARK : CLLocationManager delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    // MARK : mapView delegate
    
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
