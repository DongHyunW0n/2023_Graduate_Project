//
//  myRequestListCell.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/14.
//

import UIKit

class MyRequestListCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var isDoneLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
