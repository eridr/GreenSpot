import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        
        // define locationAccuaracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // define filter
        locationManager.distanceFilter = kCLDistanceFilterNone
        // request permission
        locationManager.requestWhenInUseAuthorization()
        // start updating location
        locationManager.startUpdatingLocation()
        // delegate self
        locationManager.delegate = self
        
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // print(location)
        DispatchQueue.main.async {
            self.location = location
        }
    }
}
