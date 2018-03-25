//
//  Restaurant.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 14.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import Foundation
class Resturant {
    var name : String?
    var type :String?
    var location :String?
    var image = NSData()
    var phone : String?
    var raiting : String?
    
    var  isVisited = false
    init(name: String, type: String , location : String ,phone: String,  image : NSData, isVisited : Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isVisited = isVisited
        self.phone = phone
    }
    
    
}
