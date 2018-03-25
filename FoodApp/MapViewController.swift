//
//  MapViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 18.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var restaurant : RestaurantMO!
    var locationManager = CLLocationManager()
    var currentPlacemark : CLPlacemark?
    override func viewDidLoad() {
        super.viewDidLoad()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.location!, completionHandler:{ placemarks, error in
            if error != nil{
                print(error!)
                return
            }
            self.mapView.delegate = self
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                if let location = placemark.location{
                    annotation.coordinate = location.coordinate
                    //self.mapView.addAnnotation(annotation)
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)}
            }
        }
            
        )
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsScale = true
        
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
    
    let reuseId = "myPin"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView : MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if annotationView == nil {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        annotationView?.canShowCallout = true
        }
        
        let leftView = UIImageView(frame: CGRect(x:0, y:0, width: 53, height: 53))
        leftView.image = UIImage(data: restaurant.image! as Data)
        annotationView?.leftCalloutAccessoryView = leftView
        return annotationView    }

    @IBAction func directionBtnTapped(_ sender: UIButton) {
        guard let placemark = currentPlacemark else {
            return
        }
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: placemark)
        directionRequest.destination = MKMapItem(placemark : destinationPlacemark)
        directionRequest.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let routeResponse = response else {
                if let error = error {
                
                print(error)
                }
                return
            }
            
            let route = routeResponse.routes[0]
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            self.mapView.setRegion(MKCoordinateRegionForMapRect(route.polyline.boundingMapRect), animated: true)

        }
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.0
        renderer.strokeColor = UIColor.red
        return renderer
    }
}
