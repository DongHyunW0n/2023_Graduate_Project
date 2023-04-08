//
//  weatherInformation.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/08.
//

import Foundation


struct weatherInformation : Codable { //코더블은 인코딩 디코딩 모두 가능 ㅋ
    
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
      case weather
      case temp = "main"
      case name
    }
  }


struct Weather : Codable {
    
    let id : Int
    let main : String
    let description : String
    let icon : String
    
}


struct Temp : Codable {
    
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        
    }
    
}
