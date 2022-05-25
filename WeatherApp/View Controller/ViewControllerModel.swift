import Foundation
import CoreLocation

// MARK: - Class
class ViewControllerModel: NSObject {
    
    //MARK: - Vars
    let locationManager = CLLocationManager()
    var lat: Double = 53.902471
    var lon: Double = 27.561822
    
    var weatherModel: WeatherModel?
    let networkService = DataFetcherService()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    var reloadTableView: (() -> ())?
    var locationNameLabel = Bindable<String?>(nil)
    var weatherStatusLabel = Bindable<String?>(nil)
    var currentTempLabel = Bindable<String?>(nil)
    var minTempLabel = Bindable<String?>(nil)
    var maxTempLabel = Bindable<String?>(nil)
    var FeelsLikeTempLabel = Bindable<String?>(nil)
    var idCurrentCondition: Int = 0
    
    var conditionName: String {
        switch idCurrentCondition {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    //MARK: - flow func
    func gpsButtonPressed () {
        self.getWeather()
    }
    
    func testCrashButton() {
        let numbers = [0]
        let _ = numbers[1]
    }
    
    func getWeather () {
        networkService.fetchWeatherData(latitude: self.lat, longitude: self.lon) { [weak self] (weather) in
            self?.weatherModel = weather
            self?.configWeatherUI()
        }
    }
  
    func configWeatherUI () {
        guard let weather = self.weatherModel,
        let currentWeather = weather.current.weather.first,
        let dailytWeather = weather.daily.first else {return}
        self.idCurrentCondition = currentWeather.id
        self.locationNameLabel.value = "\(weather.timezone.deletingSymbolBeforePrefix())"
        self.currentTempLabel.value = String(format: "%.f", weather.current.temp) + "℃"
        self.weatherStatusLabel.value = "\(currentWeather.descriptionWeather)"
        self.minTempLabel.value = String(format: "%.f", dailytWeather.temp.min) + " ℃"
        self.maxTempLabel.value = String(format: "%.f", dailytWeather.temp.max) + " ℃"
        self.FeelsLikeTempLabel.value = String(format: "%.f", weather.current.feelsLike) + "℃"
    }
}

//MARK: - Extensions
extension ViewControllerModel: SearchViewModelDelegate {
    func setLocation(_ lat: Double, _ lon: Double) {
        self.lon = lon
        self.lat = lat
        getWeather()
    }
}

extension ViewControllerModel: CLLocationManagerDelegate {
    
    func locationManagerSetup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        self.lat = location.latitude
        self.lon = location.longitude
        debugPrint(location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
    
}



