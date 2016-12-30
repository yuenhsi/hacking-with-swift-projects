//
//  Capital.swift
//  project19
//
//  Created by Yuen Hsi Chang on 12/29/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
