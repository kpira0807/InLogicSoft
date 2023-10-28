import Foundation
import CoreLocation
import UIKit

final class BikesCellViewModel {
    
    var coordination = CLLocation()
    
    let latitude: Double
    let longitude: Double
    let title: String
    let emptySlots: String
    let freeBikes: String
    
    init(
        title: String,
        emptySlots: Int,
        freeBikes: Int,
        latitude: Double,
        longitude: Double
    ) {
        self.title = title
        self.emptySlots = "Empty slots: \(emptySlots)"
        self.freeBikes = "Free bikes: \(freeBikes)"
        self.latitude = latitude
        self.longitude = longitude
        self.coordination = CLLocation(latitude: latitude, longitude: longitude)
    }
    
}
