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
                            let detail = value?["상세 설명"] as? String ?? ""
                            let imageURL = value?["사진 URL"] as? String ?? ""

                            let fetchedRequestList = requestListEntity(refid: childSnapShot.key, date: date, place: place, detail: detail, imageURL: imageURL)
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
        
        
        let firebaseAuth = Auth.auth()
        
        
        do{
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)

            
        }catch let sighOutError as NSError{
            
            print("ERROR : SIGNOUT \(sighOutError.localizedDescription)")
            
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
        
        let celldata : requestListEntity = myRequestList[indexPath.row]
        cell.titleLabel.text = celldata.detail
        cell.layer.cornerRadius = cell.frame.height/3
        cell.selectionStyle = .none
        return cell
    }

    
    
}

extension MyInformationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        print(myRequestList[indexPath.row])
        
        let celldata: requestListEntity = myRequestList[indexPath.row] //인덱스에 해당하는 셀데이터를 받음.
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MyRequestDetailViewController") as? MyRequestDetailViewController {
            detailViewController.date = celldata.date
            detailViewController.place = celldata.place
            detailViewController.detail = celldata.detail
            detailViewController.postID = celldata.refid
            
           
            detailViewController.receivedBid = 0
            navigationController?.pushViewController(detailViewController, animated: true)
            
            
           
            
        }
        
        
        
    }
    
    
}
