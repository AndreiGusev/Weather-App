import Foundation

//MARK: - Class
class LocationModel {
    
    var locations: [Location]?
    
    static let shared = LocationModel()
    private init () {}
    
    func getLocation() {
        DispatchQueue.global().async {
            LocationManager.shared.getLocations { [weak self] location in
                self?.locations = location
            }
        }
    }
}
