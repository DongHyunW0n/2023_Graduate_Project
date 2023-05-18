//
//  CustomAnnotation.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/16.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let rating: Double // 별점 정보를 저장할 프로퍼티
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, rating: Double) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.rating = rating
        super.init()
    }
}
