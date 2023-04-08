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
}

extension BannerInfo {
    static let list = [
        BannerInfo(title: "TestBanner1", description: "동서대학교 화이팅1 !"),
        BannerInfo(title: "TestBanner2", description: "동서대학교 화이팅2 !"),
        BannerInfo(title: "TestBanner3", description: "동서대학교 화이팅3 !"),
        BannerInfo(title: "TestBanner4", description: "동서대학교 화이팅4 !")
       
        
    ]
}