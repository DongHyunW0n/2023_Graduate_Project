//
//  FreeboardDetailViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/14.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class FreeboardDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableViewCell!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    var titleText : String?
    
    var detailText : String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        
        
    }
    
    func updateUI() {
            if let title = titleText {
                titleLabel.text = title
            }
            
            if let detail = detailText {
                detailTextView.text = detail
            }
        }
    
   
    

    @IBAction func addButtonTabbed(_ sender: UIButton) {
        
        
        
        
    }
    

}
