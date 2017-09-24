//
//  ViewController.swift
//  Maps
//
//  Created by Sai Madhukar on 12/07/17.
//  Copyright © 2017 Sai Madhukar. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UISearchBarDelegate,MKMapViewDelegate ,CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    let route : MKRoute! = nil
    
    var minusButton : UIButton = {

       var b = UIButton(type: UIButtonType.detailDisclosure)
        return b

    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        
       
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            print("location enabled")
                manager.delegate = self
                manager.startMonitoringSignificantLocationChanges()
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.startUpdatingLocation()
            }
        
        
       // house coordinates 17.4045075,78.4009967
        //eiffel tower coordinates 48.8583827,2.2936831
        //frankfurt sbi coordinates 50.1100516,8.6626381
        //musieum france 48.8597138,2.3263337
       // 48.8550061,2.3139662
        //let tajmahal =  CLLocationCoordinate2D(latitude: 17.3992625, longitude: 78.4921764)
        let sbi = CLLocationCoordinate2D(latitude: 48.8550061, longitude: 2.3139662)
        let kmitCoordinates = CLLocationCoordinate2D(latitude: 17.4045075, longitude: 78.4009967)
        
                let latitude = CLLocationDegrees.init(48.8597138)
               let longitude = CLLocationDegrees.init(2.3263337)
        let houseCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.region = MKCoordinateRegionMake((manager.location?.coordinate)!, span)
        
        
     
        let point1 = MKPointAnnotation()
        point1.coordinate = houseCoordinates
        point1.title = "Home"
        point1.subtitle = "My Location"
        mapView.addAnnotation(point1)
       
        let point2 = MKPointAnnotation()
        
        point2.coordinate = sbi
        point2.title = "SBI"
        point2.subtitle = "State Bank Of India"
        mapView.addAnnotation(point2)
       
     
        print(mapView.visibleMapRect)
        

        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: houseCoordinates))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: kmitCoordinates))
        directionRequest.transportType = .transit
        let direction = MKDirections(request: directionRequest)

        direction.calculate { (response, err) in
            if(err != nil) { print("Error :",err!.localizedDescription)
                return }
            print(response!.routes.first ?? "not working")
            print("Number of Routes: " + String(response!.routes.count))
            print(response!.routes[0])
            let r : MKRoute = response!.routes.first!
            self.mapView.add(r.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = r.polyline.boundingMapRect
            print(rect)
             self.mapView.setNeedsDisplay()
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            
        }
        
        
        mapView.addSubview(minusButton)
        minusButton.frame = CGRect(x: mapView.bounds.width - 70, y: mapView.bounds.height - 100, width: 50, height: 50)
        minusButton.backgroundColor = .clear
        minusButton.addTarget(self, action: #selector(zoomOut), for: UIControlEvents.touchUpInside)
        minusButton.addTarget(self, action: #selector(fastZoomOut), for: UIControlEvents.touchDownRepeat)

        
    }
    
    @objc func zoomOut()
    {

        mapView.region.span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta + 0.05, longitudeDelta: mapView.region.span.longitudeDelta + 0.05)

    }

    @objc func fastZoomOut()
    {

        mapView.region.span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta + 1, longitudeDelta: mapView.region.span.longitudeDelta + 1)

    }
    
   
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
    
   
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

