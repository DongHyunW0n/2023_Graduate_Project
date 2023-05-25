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
    var bidID: String
    var companyName: String
    var companyUID: String
    var detail: String
    var isSelected: String
}
let refDetailView = Database.database().reference().child("ServiceRequest")


class MyRequestDetailViewController: UIViewController {
    
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    
    var number : String?
    var date: String?
    var place: String?
    var detail: String?
    var postID: String?
    var receivedBid: Int?
    var requestEntity: requestListEntity?
    
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
    @IBOutlet weak var company2_OK: UIButton!
    @IBOutlet weak var company3_OK: UIButton!
    @IBOutlet weak var company4_OK: UIButton!
    @IBOutlet weak var company5_OK: UIButton!
    
    var bidDetails: [suggestEntity] = []
    
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
        print("postID는  \(postID ?? "포스트 ID 에러")")
        
        if let date = date {
            dateLabel.text = date
        }
        
        if let place = place {
            placeLabel.text = place
        }
        
        if let detail = detail {
            detailLabel.text = detail
        }
        if let number = number {
            numberLabel.text = number
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
    
    @IBAction func company1OKButtonPressed(_ sender: UIButton) {
        showConfirmationAlert(for: 0) { [weak self] in
            self?.updateSelectionStatus(for: 0, isSelected: "1")
            self?.okAlert()

        }
    }

    @IBAction func company2OKButtonPressed(_ sender: UIButton) {
        showConfirmationAlert(for: 1) { [weak self] in
            self?.updateSelectionStatus(for: 1, isSelected: "1")
            self?.okAlert()

        }
    }

    @IBAction func company3OKButtonPressed(_ sender: UIButton) {
        showConfirmationAlert(for: 2) { [weak self] in
            self?.updateSelectionStatus(for: 2, isSelected: "1")
            self?.okAlert()

        }
    }

    @IBAction func company4OKButtonPressed(_ sender: UIButton) {
        showConfirmationAlert(for: 3) { [weak self] in
            self?.updateSelectionStatus(for: 3, isSelected: "1")
            self?.okAlert()

        }
    }

    @IBAction func company5OKButtonPressed(_ sender: UIButton) {
        showConfirmationAlert(for: 4) { [weak self] in
            self?.updateSelectionStatus(for: 4, isSelected: "1")
            self?.okAlert()

        }
    }

    func showConfirmationAlert(for index: Int, completion: @escaping () -> Void) {
        
        let companyName = bidDetails[index].companyName
        let alertController = UIAlertController(title: "\(companyName)의 견적을 선택하셨습니다",
                                                message: "한번 선택하신 견적의 취소는 고객센터를 통해서만 가능합니다. 정말 선택하시겠습니까?",
                                                preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func okAlert(){
        
        
        let alert = UIAlertController(title: "확인", message: "해당 견적이 확정되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "확인얼럿클릭"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateSelectionStatus(for index: Int, isSelected: String) {
        guard index < bidDetails.count else {
            return
        }
        
        bidDetails[index].isSelected = isSelected
        
        guard let postID = postID else {
            print("POST ID ERROR")
            return
        }
        
        let selectedBidID = bidDetails[index].bidID // 견적 항목의 고유한 ID 가져오기
        let refSelectedBid = refDetailView.child(postID).child("받은 견적").child(selectedBidID)
        let isSelectedRef = refSelectedBid.child("선택여부")
        
        isSelectedRef.setValue(isSelected) { error, _ in
            if let error = error {
                print("Failed to update isSelected: \(error.localizedDescription)")
            } else {
                print("isSelected updated successfully")
                
                // 견적 선택 여부가 "1"로 변경된 경우 FinishedBid에 저장
                if isSelected == "1" {
                    self.saveSelectedBidDetails(index: index, postID: postID)
                }
            }
        }
    }
    
    func saveSelectedBidDetails(index: Int, postID: String) {
        guard index < bidDetails.count else {
            return
        }
        
        let selectedBid = bidDetails[index]
        let companyName = selectedBid.companyName
        
        // FinishedBid 노드에 회사명 노드 생성
        let finishedBidRef = Database.database().reference().child("FinishedBid").child(companyName).child(postID)
        
        let bidDetailsData: [String: Any] = [
            "postID": postID,
            "bidID": selectedBid.bidID,
            "상세 설명": selectedBid.detail,
            
        
        ]
        
        // 해당 회사의 선택된 견적 상세 정보를 저장
        finishedBidRef.setValue(bidDetailsData) { error, _ in
            if let error = error {
                print("견적 선정에 실패하였습니다. 에러는 : \(error.localizedDescription)")
            } else {
                print("견적 선택 정보가 성공적으로 저장되었습니다")
            }
        }
    }
    
    func fetchBidDetails() {
        guard let postID = postID else {
            print("POST ID ERROR")
            return
        }
        
        refDetailView.child(postID).child("받은 견적").observe(.value) { snapshot in
            if snapshot.exists() {
                self.bidDetails.removeAll() // 배열 초기화
                
                var hasSelectedBid = false // Flag to check if any bid is already selected
                
                for child in snapshot.children {
                    guard let childSnapshot = child as? DataSnapshot else { return }
                    
                    if let value = childSnapshot.value as? [String: Any],
                       let companyName = value["회사명"] as? String,
                       let isSelected = value["선택여부"] as? String,
                       let companyUID = value["사업자UID"] as? String,
                       let suggest = value["견적내용"] as? String {
                        
                        let bidID = childSnapshot.key // bidID 가져오기
                        
                        let fetchedSuggest = suggestEntity(bidID: bidID, companyName: companyName, companyUID: companyUID, detail: suggest, isSelected: isSelected)
                        self.bidDetails.append(fetchedSuggest)
                        
                        if isSelected == "1" {
                            hasSelectedBid = true
                        }
                    }
                }
                
                self.updateBidDetails(self.bidDetails)
                self.updateCompanyLabel(self.bidDetails)
                print(self.bidDetails)
                
                
                //모든 버튼 초기화
                
                if hasSelectedBid {
                    self.company1_OK.isEnabled = false
                    self.company2_OK.isEnabled = false
                    self.company3_OK.isEnabled = false
                    self.company4_OK.isEnabled = false
                    self.company5_OK.isEnabled = false
                }
            } else {
                print("스냅샷 제대로 안됨")
            }
        }
    }
    
    func updateBidDetails(_ details: [suggestEntity]) {
        let suggestDetails = details.prefix(5)
        let suggestCount = suggestDetails.count
        
        switch suggestCount {
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
            
            company1_suggest.text = suggestDetails[0].detail
        case 2:
            stackview1.isHidden = false
            stackview2.isHidden = false
            stackview3.isHidden = true
            stackview4.isHidden = true
            stackview5.isHidden = true
            stackview6.isHidden = true
            
            company1_suggest.text = suggestDetails[0].detail
            company2_suggest.text = suggestDetails[1].detail
        case 3:
            stackview1.isHidden = false
            stackview2.isHidden = false
            stackview3.isHidden = false
            stackview4.isHidden = true
            stackview5.isHidden = true
            stackview6.isHidden = true
            
            company1_suggest.text = suggestDetails[0].detail
            company2_suggest.text = suggestDetails[1].detail
            company3_suggest.text = suggestDetails[2].detail
        case 4:
            stackview1.isHidden = false
            stackview2.isHidden = false
            stackview3.isHidden = false
            stackview4.isHidden = false
            stackview5.isHidden = true
            stackview6.isHidden = true
            
            company1_suggest.text = suggestDetails[0].detail
            company2_suggest.text = suggestDetails[1].detail
            company3_suggest.text = suggestDetails[2].detail
            company4_suggest.text = suggestDetails[3].detail
        case 5:
            stackview1.isHidden = false
            stackview2.isHidden = false
            stackview3.isHidden = false
            stackview4.isHidden = false
            stackview5.isHidden = false
            stackview6.isHidden = true
            
            company1_suggest.text = suggestDetails[0].detail
            company2_suggest.text = suggestDetails[1].detail
            company3_suggest.text = suggestDetails[2].detail
            company4_suggest.text = suggestDetails[3].detail
            company5_suggest.text = suggestDetails[4].detail
        default:
            print("ERROR")
        }
    }
    
    func updateCompanyLabel(_ details: [suggestEntity]) {
        let suggestDetails = details.prefix(5)
        let suggestCount = suggestDetails.count
        
        let selectedCompanyIndex = suggestDetails.firstIndex { $0.isSelected == "1" } // Index of the selected company
        
        switch suggestCount {
        case 0:
            company1.text = ""
            company2.text = ""
            company3.text = ""
            company4.text = ""
            company5.text = ""
        case 1:
            company1.text = suggestDetails[0].companyName
            company2.text = ""
            company3.text = ""
            company4.text = ""
            company5.text = ""
        case 2:
            company1.text = suggestDetails[0].companyName
            company2.text = suggestDetails[1].companyName
            company3.text = ""
            company4.text = ""
            company5.text = ""
        case 3:
            company1.text = suggestDetails[0].companyName
            company2.text = suggestDetails[1].companyName
            company3.text = suggestDetails[2].companyName
            company4.text = ""
            company5.text = ""
        case 4:
            company1.text = suggestDetails[0].companyName
            company2.text = suggestDetails[1].companyName
            company3.text = suggestDetails[2].companyName
            company4.text = suggestDetails[3].companyName
            company5.text = ""
        case 5:
            company1.text = suggestDetails[0].companyName
            company2.text = suggestDetails[1].companyName
            company3.text = suggestDetails[2].companyName
            company4.text = suggestDetails[3].companyName
            company5.text = suggestDetails[4].companyName
        default:
            print("ERROR")
        }
        
        let stackViews = [stackview1, stackview2, stackview3, stackview4, stackview5]
        
        stackViews.forEach { stackView in
            stackView?.layer.borderWidth = 1 // 보더값 1으로 초기화
            stackView?.layer.borderColor = UIColor.gray.cgColor
            stackView?.layer.cornerRadius = 20
            stackView?.layer.backgroundColor = UIColor.white.cgColor
        }
        
//        stackViews.forEach { stackView in
//            stackView?.layer.borderWidth = 0 // 보더값 0으로 초기화
//            stackView?.layer.borderColor = UIColor.clear.cgColor
//        }
        
        if let selectedIndex = selectedCompanyIndex {
            stackViews[selectedIndex]?.layer.borderWidth = 1 // 선택된 견적의 스택뷰를 빨간색으로 칠함
            stackViews[selectedIndex]?.layer.backgroundColor = UIColor.systemMint.cgColor
            stackViews[selectedIndex]?.layer.borderColor = UIColor.red.cgColor
        }
    }
}
