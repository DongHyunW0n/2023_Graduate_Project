//
//  ChatCell.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/06/01.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var yourNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
