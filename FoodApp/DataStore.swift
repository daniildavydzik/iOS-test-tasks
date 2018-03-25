//
//  DataStore.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 16.09.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import Foundation
class DataStore{

    class var defaultLocalDB : CoreDataManager {
        return CoreDataManager.sharedInstance
    }
}
