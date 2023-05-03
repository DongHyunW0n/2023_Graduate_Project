//
//  FreeBoardTableViewCell.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/01.
//

import UIKit

class FreeBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var boardNumber: UILabel!
    
    @IBOutlet weak var boardTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
