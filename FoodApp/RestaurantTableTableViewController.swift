//
//  RestaurantTableTableViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 13.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit
import CoreData
class RestaurantTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    var restaurants:[RestaurantMO] = []
    var searchResults:[RestaurantMO] = []
    
    var searchController : UISearchController!
    
    var fetchResultCOntroller : NSFetchedResultsController<RestaurantMO>!
    var checkInRestaurants = Array(repeating: false, count:21)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target:nil, action: nil)
        let fetchRequest : NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        
            let context = DataStore.defaultLocalDB.persistentContainer.viewContext
            fetchResultCOntroller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext : context, sectionNameKeyPath: nil, cacheName: nil)
            searchController = UISearchController(searchResultsController: nil)
            tableView.tableHeaderView = searchController.searchBar

            tableView.tableHeaderView = searchController.searchBar
            fetchResultCOntroller.delegate = self
            do {
                try fetchResultCOntroller.performFetch()
                if let fetchedObjects = fetchResultCOntroller.fetchedObjects {
                    self.restaurants = fetchedObjects
                }
                
            } catch  {
                print(error)
            }
        

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        if #available(iOS 9.0, *) { self.searchController?.loadViewIfNeeded() }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnSwipe = true
        tableView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedWalkThrough") {
         return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "walkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true,completion: nil)
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if let searchText = searchString {
            searchFilter(for: searchText)
            tableView.reloadData()
        }
    }
    func searchFilter(for searchString:String)  {
        searchResults = restaurants.filter({(restaurant) -> Bool in
            if  searchString == "" {
             return true
            }else if  let name = restaurant.name {
                let isMatch = name.localizedCaseInsensitiveContains(searchString)
                return isMatch
            
            }
            else {
            return false
            }})
        
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newindexPath = newIndexPath {
                tableView.insertRows(at: [newindexPath], with:.fade )
            }
        case .delete :
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update :
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        default:
            tableView.reloadData()
        }
        if let fetchedObjects = fetchResultCOntroller.fetchedObjects{
            self.restaurants = fetchedObjects
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        }else{
        return restaurants.count
        }
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue){
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }else{
        return true
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RestaurantTableViewCell
        
        if self.checkInRestaurants[indexPath.row]{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        let restaurant = searchController.isActive ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.thumbnailImageView.layer.cornerRadius=30
        cell.thumbnailImageView.clipsToBounds=true
        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data)
        return cell
    }
   
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler:{(action, indexPath) -> Void in
            let defaultText = "Just Checking in at " + self.restaurants[indexPath.row].name!
            if let imageToShare=UIImage(data : self.restaurants[indexPath.row].image! as Data){
                
                
                
                let activityController = UIActivityViewController(activityItems: [defaultText,imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)}})
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{(action, indexPath) -> Void in

               let context = DataStore.defaultLocalDB.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultCOntroller.object(at: indexPath)
               context.delete(restaurantToDelete)
               DataStore.defaultLocalDB.saveContext()
          
        })
        editAction.backgroundColor = UIColor(red: 48.0/255.0 , green: 173.0/255.0 , blue: 99.0/255.0 , alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0 , green: 202.0/255.0 , blue: 203.0/255.0 , alpha: 1.0)
        return [editAction,deleteAction]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = searchController.isActive ? searchResults[indexPath.row] : restaurants[indexPath.row]
                searchController.isActive = false
            }
        }
    }
    
}
