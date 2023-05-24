//
//  MyRequestDetailViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/19.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


struct suggestEntity {
    
    var companyName : String
    var companyUID : String
    var detail : String
    var isSelected : String
    
}
let refDetailView = Database.database().reference().child("ServiceRequest")


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
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            updateUI()
            fetchBidDetails()
        }

        func updateUI() {
            print("postID is \(postID ?? "POST ID ERROR")")

            if let date = date {
                dateLabel.text = date
            }
            
            if let place = place {
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

    func fetchBidDetails() {
        guard let postID = postID else {
            print("POST ID ERROR")
            return
        }
//        ref.observe(.value) {snapshot in
//
//
//
//            self.articleList = []
//
//            for child in snapshot.children {
//                guard let childSnapShot = child as? DataSnapshot else {return}
//                let value = childSnapShot.value as? NSDictionary
//                let title = value?["제목"] as? String ?? ""
//                let discrib = value?["내용"] as? String ?? ""
//
//                let fetchedArticle = ArticleEntity(refid: childSnapShot.key, title: title, describ: discrib)
//
//                self.articleList.append(fetchedArticle)
//            }
//
//            self.tableView.reloadData()
//
//
//
//        }

        refDetailView.child(postID).child("받은 견적").observe(.value) { snapshot in
            if snapshot.exists() {
                
                var bidDetails : [suggestEntity] = []

                for child in snapshot.children {
                    
                    guard let childSnapshot = child as? DataSnapshot else{return}
                    
                    let value = childSnapshot.value as? NSDictionary
                    
                    let name = value?["회사명"] as? String ?? ""
                    let isSelected = value?["선택여부"] as? String ?? ""
                    let uid = value?["사업자UID"] as? String ?? ""


                    let suggest = value?["견적내용"] as? String ?? ""
                    
                    let fetchedSuggest = suggestEntity(companyName: name, companyUID: uid, detail: suggest, isSelected: isSelected)
                    
                    bidDetails.append(fetchedSuggest)
                    
                    
                }

                
                self.updateBidDetails(bidDetails)
                self.updateCompanyLabel(bidDetails)
                print(bidDetails)
            }else{
                print("스냅샷 제대로 받아오지 못함.")
            }

        }
    }

    func updateBidDetails(_ bidDetails: [suggestEntity]) {
        let labels = [company1_suggest, company2_suggest, company3_suggest, company4_suggest, company5_suggest]

        for (index, bidDetail) in bidDetails.enumerated() {
            if index < labels.count {
                labels[index]?.text = bidDetail.detail
            }
        }
    }
    
    func updateCompanyLabel(_ bidDetails: [suggestEntity]) {
        let labels = [company1, company2, company3, company4, company5]

        for (index, bidDetail) in bidDetails.enumerated() {
            if index < labels.count {
                labels[index]?.text = bidDetail.companyName
            }
        }
    }
    }
