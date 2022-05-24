import Foundation

class Location: Codable {
    var name: String
    var country: String
    var coord: Coordinate
}

class Coordinate: Codable {
    var lat: Double
    var lon: Double
}
