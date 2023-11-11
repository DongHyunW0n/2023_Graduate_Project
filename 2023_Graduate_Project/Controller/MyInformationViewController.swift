//
//  MyInformationViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/10.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


struct requestListEntity {
    
    var refid : String
    var date : String
    var place : String
    var detail : String
    var imageURL : String
    var number : String
    
}




class MyInformationViewController: UIViewController {
    
    
    var myRequestList : [requestListEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference().child("ServiceRequest")
    
    
    let currentEmail = Auth.auth().currentUser?.email ?? "고객"
    let userID = Auth.auth().currentUser?.uid
    
    
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("UID is : \(userID ?? "error")")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let searchString = "bid" // 검색할 문자열
        
        
        if let userID = userID {
            let userRef = ref.queryOrdered(byChild: "ㄱ서비스 요청자").queryEqual(toValue: userID)
            
            userRef.observe(.value) { snapshot in
                self.myRequestList = []
                
                for child in snapshot.children {
                    guard let childSnapShot = child as? DataSnapshot else { return }
                    let value = childSnapShot.value as? NSDictionary
                    
                    let totalRowCount = snapshot.childrenCount
                    let date = value?["요청 일시"] as? String ?? ""
                    let place = value?["요청 위치"] as? String ?? ""
                    let number = value?["연락처"] as? String ?? ""
                    let detail = value?["상세 설명"] as? String ?? ""
                    let imageURL = value?["사진 URL"] as? String ?? ""
                    
                    let fetchedRequestList = requestListEntity(refid: childSnapShot.key, date: date, place: place, detail: detail, imageURL: imageURL, number: number)
                    self.myRequestList.append(fetchedRequestList)
                    
                    print(totalRowCount)
                    
                }
                
                self.tableView.reloadData()
            }
            
            
        }
        
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        userNameLabel.text = "현재 로그인한 계정 : \(email)"
    }
    
    @IBAction func logoutButtonTabbed(_ sender: UIButton) {
        
        
        
                if let uid = userID{
        
                    try? Auth.auth().signOut()
                    print("로그아웃 성공")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let VC = storyboard.instantiateViewController(withIdentifier: "FirstView")
                    self.navigationController?.setViewControllers([VC], animated: true)
        
                }else{
        
                    print("로그아웃 실패")
                    
                    
                }
    }
}

extension MyInformationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRequestList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MyRequestListCell else {
            return UITableViewCell()
        }

        let celldata: requestListEntity = myRequestList[indexPath.row]
        cell.titleLabel.text = celldata.detail
        cell.layer.cornerRadius = cell.frame.height / 3
        cell.selectionStyle = .none

        // Check if the bid has been accepted
        let postID = celldata.refid
        let receivedBidRef = ref.child(postID).child("받은 견적")

        receivedBidRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                let receivedBids = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var isAccepted = false
                var hasReceivedBids = false

                for bid in receivedBids {
                    if let isSelected = bid.childSnapshot(forPath: "선택여부").value as? String {
                        hasReceivedBids = true
                        if isSelected == "1" {
                            isAccepted = true
                            break
                        }
                    }
                }

                DispatchQueue.main.async {
                    if isAccepted {
                        cell.isDoneLabel.text = "채택 완료"
                        cell.isDoneLabel.textColor = UIColor.green
                    } else {
                        if hasReceivedBids {
                            cell.isDoneLabel.text = "견적 수신"
                            cell.isDoneLabel.textColor = UIColor.orange
                        } else {
                            cell.isDoneLabel.text = "견적 대기"
                            cell.isDoneLabel.textColor = UIColor.red
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell.isDoneLabel.text = "견적 대기"
                    cell.isDoneLabel.textColor = UIColor.red
                }
            }
        }

        return cell
    }

    
    
}

extension MyInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let celldata: requestListEntity = myRequestList[indexPath.row]
        let postID = celldata.refid

        ref.child(postID).child("받은 견적").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                let columnCount = snapshot.childrenCount
                print("받은 견적의 개수: \(columnCount)")

                var isAccepted = false

                // Check if the bid has been accepted
                let receivedBids = snapshot.children.allObjects as? [DataSnapshot] ?? []
                for bid in receivedBids {
                    if let isSelected = bid.childSnapshot(forPath: "선택여부").value as? String {
                        if isSelected == "1" {
                            isAccepted = true
                            break
                        }
                    }
                }

                if isAccepted {
                    
//                    // 견적이 선택된 경우에만 저장
//                    let companyRef = Database.database().reference().child("Company").child(celldata.refid)
//                    let userDetails = [
//                        "요청 일시": celldata.date,
//                        "요청 위치": celldata.place,
//                        "상세 설명": celldata.detail,
//                        "사진 URL": celldata.imageURL
//                    ]
//                    companyRef.setValue(userDetails) { error, _ in
//                        if let error = error {
//                            print("Failed to save user details: \(error)")
//                        } else {
//                            print("User details saved successfully")
//                        }
//                    }
                } else {
                    print("견적이 선택되지 않았습니다.")
                }

                if let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestDetailViewController") as? MyRequestDetailViewController {
                    detailViewController.number = celldata.number
                    detailViewController.date = celldata.date
                    detailViewController.requestplace = celldata.place
                    detailViewController.detail = celldata.detail
                    detailViewController.postID = celldata.refid
                    detailViewController.receivedBid = Int(columnCount) // receivedBid에 columnCount 값을 할당
                    
                    detailViewController.customerNumber = celldata.number
                    detailViewController.requestDate = celldata.date
                    detailViewController.place = celldata.place
                    detailViewController.requestDetail = celldata.detail


                    self.navigationController?.pushViewController(detailViewController, animated: true)
                }
            } else {
                print("해당 글이 존재하지 않습니다.")
            }
        }
    }
}
