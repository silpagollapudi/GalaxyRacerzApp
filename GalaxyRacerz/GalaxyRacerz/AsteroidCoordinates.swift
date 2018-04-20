//
//  AsteroidCoordinates.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 4/19/18.
//  Copyright © 2018 patel. All rights reserved.
//

import Foundation

class AsteroidCoordinates: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coordinates, forKey: "coords")
    }
    
    init(coords: [Float]) {
        super.init()
        self.coordinates = coords 
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.coordinates = aDecoder.decodeObject(forKey: "coords") as? [Float]
        super.init() 
    }
    
    var coordinates: [Float]?
}
