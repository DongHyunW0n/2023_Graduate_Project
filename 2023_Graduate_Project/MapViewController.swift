//
//  MainViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/03/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let map = MKMapView()
    let coordinate = CLLocationCoordinate2D(
        latitude: 35.19716238064634,
        longitude: 129.06314400423676)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(map)
        map.frame = view.bounds
        
        map.setRegion(MKCoordinateRegion(center: coordinate,
                                         span: MKCoordinateSpan(
                                            latitudeDelta: 0.1,
                                            longitudeDelta: 0.1
                                         )
                                        ),
                      animated: false)
        
        map.delegate = self
        addCustomPin()
        
    }

    private func addCustomPin(){
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "우리집"
        pin.subtitle = "사직자이"
        map.addAnnotation(pin)
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else{
            return nil
        }
        
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil{
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
            
            //create the view
        }
        else{
            annotationView?.annotation = annotation
        }
        
        
        annotationView?.image = UIImage(named: "mapMarker")
        
        
        return annotationView
    }

}
