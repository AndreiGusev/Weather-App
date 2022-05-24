import Foundation
import CoreLocation

protocol SearchViewModelDelegate: AnyObject {
    func setLocation(_ lat: Double, _ lon: Double)
}

// MARK: - Class
class SearchViewModel: NSObject {
    
    // MARK: - vars/lets
    weak var delegate: SearchViewModelDelegate?
    let locationManager = CLLocationManager()
    var reloadTableView: (() -> ())?
    var listLocations = [Location]()
    var lat: Double?
    var lon: Double?
    var cellViewModel = [SearchTableViewCellModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    var searchResults: Int {
        if listLocations.count > 10 {
            return 10
        } else if listLocations.count > 0 {
            return listLocations.count
        } else {
            return 1
        }
    }
    
    // MARK: - Flow func
    func isLocationListEmpty() -> Bool {
        listLocations.isEmpty
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if listLocations.isEmpty {
            self.delegate?.setLocation(self.lat ?? 53.902471, self.lon ?? 27.561822)
        } else {
            self.delegate?.setLocation(listLocations[indexPath.row].coord.lat, listLocations[indexPath.row].coord.lon)
        }
    }
    
    func getLocation() {
        getCurrentLocation()
    }
    
    func searchLocation(text: String) {
        guard let locations = LocationModel.shared.locations else { return }
        
        listLocations = locations.filter({ (location: Location) in
            if text.count > 2 && location.name.lowercased().contains(text.lowercased()) {
                return true
            }
            return false
        })
        listLocations.sort(by: {$0.name.count < $1.name.count})
        createCell()
        reloadTableView?()
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> SearchTableViewCellModel {
        return cellViewModel[indexPath.row]
    }
    
    func createCell() {
        var cell = [SearchTableViewCellModel]()
        for location in listLocations {
            cell.append(SearchTableViewCellModel(location: location.name, country: location.country))
        }
        self.cellViewModel = cell
    }
    
}

struct SearchTableViewCellModel {
    var location: String
    var country: String
}

// MARK: - Extension
extension SearchViewModel: CLLocationManagerDelegate {
    private func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        lat = location.latitude
        lon = location.longitude
        locationManager.stopUpdatingLocation()
    }
}
