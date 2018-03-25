//
//  LoanDetailViewController.swift
//  KivaLoan
//
//  Created by Daniel Davydzik on 25/03/2018.
//Copyright © 2018 DavydzikInc. All rights reserved.
import UIKit
import MapKit
class LoanDetailViewController:UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var tableView:UITableView!
    
    var loan : LoanMO?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! DetailLoanTableViewCell
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = loan?.name
        case 1:
            cell.fieldLabel.text = "Country"
            cell.valueLabel.text = loan?.country
        case 2:
            cell.fieldLabel.text = "Use"
            cell.valueLabel.text = loan?.use
        case 3:
            cell.fieldLabel.text = "Amount"
            cell.valueLabel.text = String(describing :(loan?.loan_amount)!)
            
        
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
        createMapAnnotation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createMapAnnotation() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString((loan?.country)!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error as Any)
                return
            }
            if let placemarks = placemarks {
                
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 800000, 3000)
                    self.mapView.setRegion(region, animated: false)
                    self.mapView.mapType = .standard
                }
            } })
    }

}
