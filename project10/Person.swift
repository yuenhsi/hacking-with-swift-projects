//
//  Person.swift
//  project10
//
//  Created by Yuen Hsi Chang on 12/23/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
