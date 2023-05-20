//
//  MyRequestDetailViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/19.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class MyRequestDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    
    var date : String?
    var place : String?
    var detail : String?
    
    var received : Bool?
    
    @IBOutlet weak var company1: UILabel!
    @IBOutlet weak var company2: UILabel!
    @IBOutlet weak var company3: UILabel!
    @IBOutlet weak var company4: UILabel!
    @IBOutlet weak var company5: UILabel!
    @IBOutlet weak var stackview1: UIStackView!
    @IBOutlet weak var stackview2: UIStackView!
    @IBOutlet weak var stackview3: UIStackView!
    @IBOutlet weak var stackview4: UIStackView!
    @IBOutlet weak var stackview5: UIStackView!
    
    @IBOutlet weak var company1_suggest: UILabel!
    @IBOutlet weak var company2_suggest: UILabel!
    @IBOutlet weak var company3_suggest: UILabel!
    @IBOutlet weak var company4_suggest: UILabel!
    @IBOutlet weak var company5_suggest: UILabel!

    @IBOutlet weak var company1_OK: UIButton!
    @IBOutlet weak var company1_NO: UIButton!
    
    @IBOutlet weak var company2_OK: UIButton!
    @IBOutlet weak var company2_NO: UIButton!
    
    @IBOutlet weak var company3_OK: UIButton!
    @IBOutlet weak var company3_NO: UIButton!
    
    @IBOutlet weak var company4_OK: UIButton!
    @IBOutlet weak var company4_NO: UIButton!
    
    @IBOutlet weak var company5_OK: UIButton!
    @IBOutlet weak var company5_NO: UIButton!
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
    }
    

    func updateUI(){
        if let date = date{
            dateLabel.text = date
        }
        
        if let place = place{
            placeLabel.text = place
        }
        
        if let detail = detail {
            detailLabel.text = detail
        }

        
        
        
    }

}
