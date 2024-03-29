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
        BannerInfo(title: "동서대학교 AI 언박싱", description: "화이팅", imageName: "showme" ),
        BannerInfo(title: "TestBanner2", description: "동서대학교 화이팅2 !", imageName: "showme" ),
        BannerInfo(title: "TestBanner3", description: "동서대학교 화이팅3 !", imageName: "showme" ),
        BannerInfo(title: "TestBanner4", description: "동서대학교 화이팅4 !", imageName: "showme" )
       
        
    ]
}
