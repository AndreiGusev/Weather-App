import Foundation

//MARK: - Class
class LocationManager {
    
    static let shared = LocationManager()
    private init () {}

    func getLocations(compelition: @escaping ([Location]) -> ()) {
        
        guard let path = Bundle.main.path(forResource: "city", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let object = try JSONDecoder().decode([Location].self, from: data)
            DispatchQueue.main.async {
                compelition(object)
            }
        } catch {
            debugPrint(error)
        }
    }
}
