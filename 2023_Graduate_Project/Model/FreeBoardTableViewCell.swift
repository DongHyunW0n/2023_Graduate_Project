//
//  FreeBoardTableViewCell.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/01.
//

import UIKit

class FreeBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var boardTitle: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        commentView.layer.cornerRadius = commentView.bounds.height / 2.0
              commentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
