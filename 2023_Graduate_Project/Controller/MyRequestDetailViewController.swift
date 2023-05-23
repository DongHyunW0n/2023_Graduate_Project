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
    var postID : String?
    var receivedBid : Int?
    
    var requestEntity : requestListEntity?
    
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
    
    @IBOutlet weak var stackview6: UIStackView!
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
        
        detailLabel.isEditable = false

        let postRef = ref.child("ServiceRequest").child(postID ?? "ERROR")

        
        print("postID is \(postID ?? "POST ID ERROR")")
        
        
        
        postRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                let rowCount = snapshot.childrenCount
                print("행의 개수: \(rowCount)")
            } else {
                print("해당 글이 존재하지 않습니다.")
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()

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

        if let receivedBid = receivedBid {
            
            switch receivedBid {
                
                
            case 0:
                stackview1.isHidden = true
                stackview2.isHidden = true
                stackview3.isHidden = true
                stackview4.isHidden = true
                stackview5.isHidden = true
                stackview6.isHidden = false

            case 1:
                stackview1.isHidden = false
                stackview2.isHidden = true
                stackview3.isHidden = true
                stackview4.isHidden = true
                stackview5.isHidden = true
                stackview6.isHidden = true

                
            case 2:
                stackview1.isHidden = false
                stackview2.isHidden = false
                stackview3.isHidden = true
                stackview4.isHidden = true
                stackview5.isHidden = true
                stackview6.isHidden = true

            case 3:
                stackview1.isHidden = false
                stackview2.isHidden = false
                stackview3.isHidden = false
                stackview4.isHidden = true
                stackview5.isHidden = true
                stackview6.isHidden = true

            case 4:
                stackview1.isHidden = false
                stackview2.isHidden = false
                stackview3.isHidden = false
                stackview4.isHidden = false
                stackview5.isHidden = true
                stackview6.isHidden = true

            case 5:
                stackview1.isHidden = false
                stackview2.isHidden = false
                stackview3.isHidden = false
                stackview4.isHidden = false
                stackview5.isHidden = false
                stackview6.isHidden = true


            default:
                print("ERROR")
            }
            
            
        }
        
        
        
    }

}
