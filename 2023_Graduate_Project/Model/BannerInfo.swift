//
//  BannerInfo.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/08.
//

import Foundation


struct BannerInfo: Hashable {
    let title: String
    let description: String
    let imageName : String
}

extension BannerInfo {
    static let list = [
        BannerInfo(title: "당신을 위한 완벽한 서비스", description: "도와줘요 맥가이버! 드디어 서비스 정식 런칭 !!", imageName: "spannerImage" ),
        BannerInfo(title: "TestBanner2", description: "동서대학교 화이팅2 !", imageName: "mapMarker" ),
        BannerInfo(title: "TestBanner3", description: "동서대학교 화이팅3 !", imageName: "mapMarker" ),
        BannerInfo(title: "TestBanner4", description: "동서대학교 화이팅4 !", imageName: "mapMarker" )
       
        
    ]
}
