//
//  WriteBoardStruct.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/09.
//

import Foundation


struct Article : Codable {
    
    let Detail : String
    let Title : String
    
    
    var toDictionary : [String : Any] {
        
        let dict : [String : Any] = ["title" : title , "detail" : detail]
        return dict
    }
    
}
