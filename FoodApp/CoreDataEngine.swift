//
//  CoreDataEngine.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 16.09.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import Foundation
import CoreData
class CoreDataEngine {

    static let sharedInstance : CoreDataEngine = {CoreDataEngine()}()
    
    func addRestaurant(restaur : Resturant)  {
        let restaurant = RestaurantMO(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
             restaurant.name = restaur.name
             restaurant.location = restaur.location
             restaurant.phone = restaur.phone
             restaurant.isVisited = restaur.isVisited
             restaurant.type = restaur.type
             restaurant.raiting = restaur.raiting
             restaurant.image = restaur.image
         print("Save Data To Context ")
         CoreDataManager.sharedInstance.saveContext()
        //        restaurant.name = restaurant.name
//        restaurant.location = restaurant.location
//        restaurant.phone = restaurant.phone
        
        
    }
    func fetchRestaurants() -> [RestaurantMO] {
        let fetchRequest : NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
//        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
            let fetchResultCOntroller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext : context, sectionNameKeyPath: nil, cacheName: nil)
            
             
            
            do {
                try fetchResultCOntroller.performFetch()
                if let fetchedObjects = fetchResultCOntroller.fetchedObjects {
                    return fetchedObjects
                }
                
            } catch  {
                print(error)
            }
            return []
    }}
            
            
        
    

