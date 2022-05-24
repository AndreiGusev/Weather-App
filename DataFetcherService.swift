import Foundation
import CoreLocation

//MARK: - Class
class DataFetcherService {
    
    var networkDataFetcher = NetworkDataFetcher()
    
    // MARK: - func
    func fetchWeatherData (latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (WeatherModel?) -> Void) {
        let urlString = APIManager.shared.getLocationCurrentWeatherURL(latitude: latitude, longitude: longitude)
        print(urlString)
        networkDataFetcher.fetchData(urlString: urlString, completion: completion)
    }
    
}
