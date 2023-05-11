//
//  MainViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/03/24.
//

import UIKit
import MapKit
import CoreLocation
import Charts


class MapViewController: UIViewController, MKMapViewDelegate {
    
    let map = MKMapView()
    var coordinate1 = CLLocationCoordinate2D(
        latitude: 35.19716238064634,
        longitude: 129.06314400423676)
    var coordinate2 = CLLocationCoordinate2D(
        latitude: 35.19716238064634,
        longitude: 129.08314500423676)
    var coordinate3 = CLLocationCoordinate2D(
        latitude: 35.27716238064634,
        longitude: 129.08314500423676)

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        view.addSubview(map)
        map.frame = view.bounds
        
        map.setRegion(MKCoordinateRegion(center: coordinate1,
                                         span: MKCoordinateSpan(
                                            latitudeDelta: 0.1,
                                            longitudeDelta: 0.1
                                         )
                                        ),
                      animated: false)
        
        map.delegate = self
        addCustomPin1(title: "test3", subtitle: "test3", latitude: 35.196, longitude: 129.08)
        addCustomPin2(title: "테스트 입니다", subtitle: "테스트 입니다당", latitude: 35.18, longitude: 129.1)
        addCustomPin3(title: "테스트 입니다", subtitle: "테스트 입니다당", latitude: 35.18, longitude: 129.1)

        
    }

    private func setCoordinate (){
        
        
        
    }
    
    private func addCustomPin1( title : String, subtitle : String, latitude : Double, longitude : Double){
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate1
        pin.title  = title
        pin.subtitle = subtitle
        map.addAnnotation(pin)
        let lat = latitude
        let long = longitude
        
        let coordinate = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
        
        
    }
    
    private func addCustomPin2( title : String, subtitle : String, latitude : Double, longitude : Double){
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate2
        pin.title  = title
        pin.subtitle = subtitle
        map.addAnnotation(pin)
        let lat = latitude
        let long = longitude
        
        let coordinate = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
        
        
    }
    
    private func addCustomPin3( title : String, subtitle : String, latitude : Double, longitude : Double){
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate3
        pin.title  = title
        pin.subtitle = subtitle
        map.addAnnotation(pin)
        let lat = latitude
        let long = longitude
        
        let coordinate = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
        
        
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
