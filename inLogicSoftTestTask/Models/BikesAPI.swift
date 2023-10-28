import Foundation

struct BikesAPI: Codable {
    
    var network: Networks
    
}

struct Networks: Codable {
    
    var href: String?
    var id: String?
    var name: String?
    var location: Location
    var stations: [Stations]
    
}

struct Location: Codable {
    
    var city: String?
    var country: String?
    var latitude: Double?
    var longitude: Double?
    
}

struct Stations: Codable {
    
    var emptySlots: Int?
    var freeBikes: Int?
    var id: String?
    var latitude: Double?
    var longitude: Double?
    var name: String
    var timestamp: String?
    var extra: Extra
    
    enum CodingKeys: String, CodingKey {
        case emptySlots = "empty_slots"
        case freeBikes = "free_bikes"
        case id
        case latitude
        case longitude
        case name
        case timestamp
        case extra
    }
    
}

struct Extra: Codable {
    
    var address: String?
    var ebikes: Int?
    var electricFree: Int?
    var electricSlots: Int?
    var normalBikes: Int?
    var normalFree: Int?
    var normalSlots: Int?
    var slots: Int?
    var uid: String?
    
    enum CodingKeys: String, CodingKey {
        case electricFree = "electric_free"
        case electricSlots = "electric_slots"
        case normalBikes = "normal_bikes"
        case normalFree = "normal_free"
        case normalSlots = "normal_slots"
        case address
        case ebikes
        case slots
        case uid
    }
    
}
