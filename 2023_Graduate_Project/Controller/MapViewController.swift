//
//  MainViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/03/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MapView의 delegate를 self로 설정
        mapView.delegate = self
        locationManager.delegate = self
        
        // 위치 권한 요청
               locationManager.requestWhenInUseAuthorization()

        
        // 현재 위치 표시 설정
                mapView.showsUserLocation = true
        
        var coordinate3 = CLLocationCoordinate2D(
            latitude: 35.196,
            longitude: 129.08)
        // 샘플 어노테이션 데이터
        let annotation1 = CustomAnnotation(title: "동서 철물", subtitle: "배관 전문점", coordinate: CLLocationCoordinate2D(latitude: 35.196, longitude: 129.08), rating: 4.5)
        let annotation2 = CustomAnnotation(title: "경남 철물", subtitle: "도배 전문점", coordinate: CLLocationCoordinate2D(latitude: 35.18, longitude: 129.1), rating: 4.8)
        let annotation3 = CustomAnnotation(title: "부산 철물", subtitle: "도배 전문점", coordinate: CLLocationCoordinate2D(latitude: 35.156, longitude: 129.05), rating: 4.8)
        let annotation4 = CustomAnnotation(title: "해운대 철물", subtitle: "도배 전문점", coordinate: CLLocationCoordinate2D(latitude: 35.15, longitude: 129.12), rating: 4.8)
        
        // 어노테이션을 MapView에 추가
        mapView.addAnnotations([annotation1, annotation2 , annotation3, annotation4])
        
        // 초기 맵 뷰 영역 설정
        let centerCoordinate = coordinate3
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          guard let location = locations.last else { return }
          
          // 현재 위치를 지도의 중심으로 설정
          let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
          mapView.setRegion(region, animated: true)
          
          // 현재 위치 업데이트 중단
          locationManager.stopUpdatingLocation()
      }
    
    // 어노테이션 뷰를 커스텀하여 별점과 정보를 표시
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        let identifier = "CustomAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = customAnnotation
        }
        
        // 별점을 표시하는 라벨
        let ratingLabel = UILabel()
        ratingLabel.text = "평점: \(customAnnotation.rating)"
        
        annotationView?.detailCalloutAccessoryView = ratingLabel
        
        return annotationView
    }
    
    // 어노테이션 선택 시 호출되는 메서드
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let customAnnotation = view.annotation as? CustomAnnotation else {
            return
        }
        
        // 선택한 어노테이션의 정보를 표시하는 알림창 생성
        let alertController = UIAlertController(title: customAnnotation.title, message: customAnnotation.subtitle, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
