//
//  RestaurantDetailViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 14.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit
import MapKit
class RestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationDetailLabel: UILabel!
    @IBOutlet weak var typeDetailLabel: UILabel!
    @IBOutlet weak var nameDetailLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    @IBAction func ratingBtnTapped(segue: UIStoryboardSegue){
        if let id = segue.identifier{
        self.restaurant.isVisited = true
            switch id {
            case "great":
                self.restaurant.raiting = "great"
            case "good":
                self.restaurant.raiting = "good"
            case "dislike":
                self.restaurant.raiting = "dislike"
            default:
                break
            }
                DataStore.defaultLocalDB.saveContext()
            tableView.reloadData()
        
        }
    }

    var restaurant:RestaurantMO!
    @IBAction func close(segue: UIStoryboardSegue){
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantImageView.image = UIImage(data: restaurant.image! as Data)
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0,green: 240.0/255.0,blue: 240.0/255.0, alpha: 0.2 )
        title = self.restaurant.name
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView?.addGestureRecognizer(tapGestureRecognizer)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.location!, completionHandler:{ placemarks, error in
            if error != nil{
            print(error!)
            return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                if let location = placemark.location{
                annotation.coordinate = location.coordinate
                self.mapView.addAnnotation(annotation)
                    
                let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate , 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
        )}
    func showMap()  {
        self.performSegue(withIdentifier: "showMap", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentView"{
        let destinationContrl = segue.destination as! ReviewViewController
        destinationContrl.restaurant  = restaurant

        }else if segue.identifier == "showMap"{
            let destinationContrl = segue.destination as! MapViewController
            destinationContrl.restaurant  = restaurant
        }
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
    switch indexPath.row {
    case 0:
        cell.fieldLabel.text = NSLocalizedString("Name", comment: "Name  Field")
        cell.valueLabel.text = restaurant.name
    case 1:
        cell.fieldLabel.text = NSLocalizedString("Type", comment: "Type  Field")
        cell.valueLabel.text = restaurant.type
    case 2:
        cell.fieldLabel.text = NSLocalizedString("Location", comment: "Location/Adress  Field")
        cell.valueLabel.text = restaurant.location

    case 3:
        cell.fieldLabel.text = NSLocalizedString("Phone", comment: "Phone  Field")
        cell.valueLabel.text = restaurant.phone
    case 4:
        cell.fieldLabel.text = NSLocalizedString("Been there?", comment: "Been there? Field")
        cell.valueLabel.text = restaurant.isVisited ?NSLocalizedString("Yes, i've been there before \(self.restaurant.raiting ?? "")", comment: "Yes, i've been there before")  : NSLocalizedString("No", comment: "Yes, i've not been there before")

    default:
        cell.fieldLabel.text = ""
        cell.valueLabel.text = ""
    }
    cell.backgroundColor = UIColor.clear
    return cell
    }
}
