//
//  PinAnnotation.swift
//  pins
//
//  Created by 주동석 on 11/23/23.
//

import MapKit
import Foundation

final class PinAnnotation: NSObject, MKAnnotation {
    var pin: Pin
    var imageName: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
    }
    
    init(pin: Pin) {
        self.pin = pin
        self.imageName = Category.convertToImageName(category: pin.category)
    }
}
