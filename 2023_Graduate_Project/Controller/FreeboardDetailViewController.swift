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
    
    @IBOutlet weak var detailTextView: UITextView!
    
    var titleText : String!
    
    var detailText : String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        
        
    }
    
    func updateUI(){
        
        if let title = self.titleText, let detail = self.detailText {
            
            titleLabel.text = ""
            detailTextView.text = ""
            
            titleLabel.text = title
            detailTextView.text = detail
            
            
        }
        
        
        
        
        
    }
    
   
    

   

}
