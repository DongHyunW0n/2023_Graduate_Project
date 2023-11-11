//
//  BannerCell.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/08.
//

import Foundation
import UIKit

class BannerCell: UICollectionViewCell {
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
    }
    
    func configure(_ info: BannerInfo) {
    
   
        thumbnailImageView.image = UIImage(named: info.imageName)
    }
}
