//
//  FreeboardCommentCell.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/06/01.
//

import UIKit
import Combine



class FreeboardCommentCell: UITableViewCell {
    
   
    
    

    @IBOutlet weak var writterLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

    }

}
